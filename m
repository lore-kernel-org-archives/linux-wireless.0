Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:48390 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751289AbdKMKHn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 05:07:43 -0500
Message-ID: <1510567660.30497.32.camel@sipsolutions.net> (sfid-20171113_110756_077572_A4AE201D)
Subject: Re: [RFC] cfg80211: Implement Multiple BSSID capability in scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Peng Xu <pxu@qti.qualcomm.com>
Date: Mon, 13 Nov 2017 11:07:40 +0100
In-Reply-To: <1509554358-10473-1-git-send-email-jouni@qca.qualcomm.com>
References: <1509554358-10473-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Thanks for working on this.

> +u8 *gen_new_bssid(const u8 *bssid, u8 max_bssid, u8 mbssid_index, gfp_t gfp)

I looks like this should be static? I'm also pretty sure you leak the
result, I guess you shouldn't allocate memory here. Just passing in a
pointer to a buffer (that could be on the stack in the caller) would
work fine, afaict.

> +{
> +	int i;
> +	u64 bssid_a, bssid_b, bssid_tmp = 0;
> +	u64 lsb_n;
> +	u8 *new_bssid;
> +
> +	for (i = 0; i < 5; i++) {
> +		bssid_tmp = bssid_tmp | bssid[i];
> +		bssid_tmp = bssid_tmp << 8;
> +	}

ether_addr_to_u64()

> +	bssid_tmp = bssid_tmp | bssid[5];
> +
> +	lsb_n = bssid_tmp & ((1 << max_bssid) - 1);
> +	bssid_b = (lsb_n + mbssid_index) % (1 <<  max_bssid);
> +	bssid_a = bssid_tmp & ~((1 << max_bssid) - 1);
> +	bssid_tmp = bssid_a | bssid_b;

This seems like a somewhat roundabout way of getting this, even if this
is how the spec says it's done. How about just

	new_bssid = bssid_tmp;
	new_bssid &= ~((1 << max_bssid) - 1);
	new_bssid |= (lsb_n + mbssid_index) % (1 << max_bssid);

> +	new_bssid = kzalloc(6, gfp);
> +	if (!new_bssid)
> +		return NULL;

don't allocate

> +	for (i = 0; i < 6; i++) {
> +		new_bssid[5 - i] = bssid_tmp & 0xFF;
> +		bssid_tmp >>= 8;
> +	}

u64_to_ether_addr()


Also, wouldn't it be better to handle both the index and list option
from the Co-Located BSSID List subelement in the same function?


> +size_t calculate_new_ie_len(const u8 *ie, size_t ielen, const u8 *subelement,
> +			    size_t subie_len)

static

> +{
> +	size_t new_ie_len;
> +	const u8 *old_ie, *new_ie;
> +	int delta;
> +
> +	new_ie_len = ielen;
> +
> +	/* calculate length difference between ssid ie */
> +	old_ie = cfg80211_find_ie(WLAN_EID_SSID, ie, ielen);
> +	new_ie = cfg80211_find_ie(WLAN_EID_SSID, subelement, subie_len);
> +	if (old_ie && new_ie) {
> +		delta = new_ie[1] - old_ie[1];
> +		new_ie_len += delta;
> +	}

No need for the delta variable. Also, this goes wrong if old_ie is
missing but new_ie is present. Probably can't happen, but still.

> +	/* calculate length difference between FMS Descriptor ie */
> +	old_ie = cfg80211_find_ie(WLAN_EID_FMS_DESCRIPTOR, ie, ielen);
> +	new_ie = cfg80211_find_ie(WLAN_EID_FMS_DESCRIPTOR, subelement,
> +				  subie_len);
> +	if (!old_ie && new_ie)
> +		new_ie_len += new_ie[1];
> +	else if (old_ie && new_ie)
> +		new_ie_len += (new_ie[1] - old_ie[1]);

Technically that's missing teh old_ie && !new_ie case. Perhaps you
should pull that out into a small separate function:

	new_ie_len += ie_len_delta(WLAN_EID_SSID, ie, ielen,
				   subelement, subie_len);

or so.

> +	/* calculate length difference for same vendor ie */
> +	new_ie = cfg80211_find_ie(WLAN_EID_VENDOR_SPECIFIC, subelement,
> +				  subie_len);
> +	while (new_ie && (new_ie - subelement) < subie_len) {
> +		old_ie = cfg80211_find_ie(WLAN_EID_VENDOR_SPECIFIC, ie, ielen);
> +		while (old_ie && ((old_ie - ie) < ielen)) {
> +			if (!memcmp(new_ie + 2, old_ie + 2, 5)) {
> +				/* same vendor ie, calculate length difference*/
> +				new_ie_len += (new_ie[1] - old_ie[1]);
> +				break;
> +			}
> +			old_ie = cfg80211_find_ie(
> +					WLAN_EID_VENDOR_SPECIFIC,
> +					old_ie + old_ie[1] + 2,
> +					ielen - (old_ie + old_ie[1] + 2 - ie));
> +		}
> +		new_ie = cfg80211_find_ie(WLAN_EID_VENDOR_SPECIFIC,
> +					  new_ie + new_ie[1] + 2,
> +					  subie_len -
> +					  (new_ie + new_ie[1] + 2 -
> +					  subelement));
> +	}

Perhaps that could be used here too, though I'm not really sure exactly
what you're doing here.

Can you add a comment pointing to where this logic is mentioned in the
spec?

> +	/* check other ie in subelement */
> +	new_ie = cfg80211_find_ie(WLAN_EID_NON_TX_BSSID_CAP, subelement,
> +				  subie_len);
> +	while (new_ie && (new_ie - subelement < subie_len)) {
> +		if (new_ie[0] == WLAN_EID_NON_TX_BSSID_CAP ||
> +		    new_ie[0] == WLAN_EID_SSID ||
> +		    new_ie[0] == WLAN_EID_FMS_DESCRIPTOR ||
> +		    new_ie[0] == WLAN_EID_MULTI_BSSID_IDX) {
> +			if ((new_ie + 2 + new_ie[1] - subelement) ==
> +			     subie_len) {
> +				/* new_ie is the last ie */
> +				break;
> +			}
> +			new_ie += new_ie[1] + 2;
> +			continue;
> +		}
> +		new_ie_len += (new_ie[1] + 2);
> +		if ((new_ie + 2 + new_ie[1] - subelement) == subie_len) {
> +			/* new_ie is the last ie */
> +			break;
> +		}
> +		new_ie += new_ie[1] + 2;
> +	}

This also seems pretty complex, perhaps pull it out and add comments?
I'm not really sure I understand it at all.

> +u8 *gen_new_ie(const u8 *ie, size_t ielen, const u8 *subelement,
> +	       size_t subie_len, size_t new_ie_len, bool is_beacon,
> +	       gfp_t gfp)

Again, static (I'll stop with that, please run sparse).

Also, again, not sure how you free this?

> +{
> +	u8 *new_ie, *pos;
> +	const u8 *tmp_old, *tmp_new, *tmp;
> +	size_t left_len;
> +
> +	new_ie = kzalloc(new_ie_len, gfp);
> +	if (!new_ie)
> +		return NULL;
> +
> +	pos = new_ie;
> +
> +	/* set new ssid */
> +	tmp_new = cfg80211_find_ie(WLAN_EID_SSID, subelement, subie_len);
> +	if (tmp_new) {
> +		memcpy(pos, tmp_new, tmp_new[1] + 2);
> +		pos += (tmp_new[1] + 2);
> +	}
> +
> +	/* go through IEs in ie and subelement, merge them into new_ie */
> +	tmp_old = cfg80211_find_ie(WLAN_EID_SSID, ie, ielen);
> +	if (!tmp_old)
> +		return NULL;
> +	tmp_old += tmp_old[1] + 2;
> +	tmp_new = cfg80211_find_ie(WLAN_EID_SSID, subelement, subie_len);
> +	left_len = subie_len - tmp_new[1];
> +	tmp_new += tmp_new[1] + 2;
> +
> +	while ((tmp_old - ie) < ielen) {
> +		if (tmp_old[0] == 0) {
> +			tmp_old++;
> +			continue;
> +		}
> +
> +		tmp = cfg80211_find_ie(tmp_old[0], tmp_new, left_len);
> +		if (!tmp) {
> +			/* ie in old ie but not in subelement */
> +			memcpy(pos, tmp_old, tmp_old[1] + 2);
> +			pos += tmp_old[1] + 2;
> +		} else {
> +			if (tmp_old[0] == WLAN_EID_MULTIPLE_BSSID)
> +				continue;
> +
> +			if (tmp_old[0] == WLAN_EID_VENDOR_SPECIFIC) {
> +				if (!memcmp(tmp_old + 2, tmp + 2, 5)) {
> +					/* same vendor ie, copy from new ie */
> +					memcpy(pos, tmp, tmp[1] + 2);
> +					pos += tmp[1] + 2;
> +				} else {
> +					memcpy(pos, tmp_old, tmp_old[1] + 2);
> +					pos += tmp_old[1] + 2;
> +				}
> +				tmp_old += tmp_old[1] + 2;
> +				continue;
> +			}
> +
> +			/* copy ie from subelement into new ie */
> +			memcpy(pos, tmp, tmp[1] + 2);
> +			pos += tmp[1] + 2;
> +		}
> +		tmp_old += tmp_old[1] + 2;
> +	}
> +
> +	while ((tmp_new - subelement) < subie_len) {
> +		tmp = cfg80211_find_ie(tmp_new[0], new_ie, pos - new_ie);
> +		if (!tmp && tmp_new[0] != WLAN_EID_MULTI_BSSID_IDX) {
> +			/* ie is new ie but not in new_ie */
> +			memcpy(pos, tmp_new, tmp_new[1] + 2);
> +			pos += tmp_new[1] + 2;
> +		} else {
> +			if (tmp && tmp_new[0] == WLAN_EID_VENDOR_SPECIFIC)
> +				if (memcmp(tmp_new + 2, tmp + 2, 5)) {
> +					memcpy(pos, tmp_new, tmp_new[1] + 2);
> +					pos += tmp_new[1] + 2;
> +				}
> +		}
> +		tmp_new += tmp_new[1] + 2;
> +	}
> +
> +	return new_ie;
> +}

This is pretty similar logic to the length calculations above.

Perhaps this one could be implemented with some kind of making all the
memcpy()s optional, and then you could call it with a NULL output
buffer to calculate the length, or something like that?


> +void add_nontrans_list(struct cfg80211_internal_bss *trans_bss,
> +		       struct cfg80211_internal_bss *nontrans_bss)
> +{
> +	const u8 *ssid;
> +	size_t ssid_len;
> +	struct cfg80211_internal_bss *bss = NULL;
> +
> +	ssid = ieee80211_bss_get_ie(&nontrans_bss->pub, WLAN_EID_SSID);
> +	if (!ssid)
> +		return;
> +	ssid_len = ssid[1];
> +	ssid = ssid + 2;
> +
> +	/* check if nontrans_bss is in the list */
> +	if (!list_empty(&trans_bss->nontrans_list)) {
> +		list_for_each_entry(bss, &trans_bss->nontrans_list,
> +				    nontrans_list) {

There's no value in checking if a list is empty before iterating it, if
you just iterate an empty list you'll iterate zero times :)

> +			if (is_bss(&bss->pub, nontrans_bss->pub.bssid,
> +				   ssid, ssid_len))
> +				return;

It seems to me that you need to return some kind of status, to figure
out whether or not the new entry should be freed?

Overall, the memory allocation/tracking here seems to need quite a bit
of work.

>  /* Returned bss is reference counted and must be cleaned up appropriately. */
>  struct cfg80211_bss *
> -cfg80211_inform_bss_data(struct wiphy *wiphy,
> -			 struct cfg80211_inform_bss *data,
> -			 enum cfg80211_bss_frame_type ftype,
> -			 const u8 *bssid, u64 tsf, u16 capability,
> -			 u16 beacon_interval, const u8 *ie, size_t ielen,
> -			 gfp_t gfp)
> +cfg80211_inform_single_bss_data(struct wiphy *wiphy,
> +				struct cfg80211_inform_bss *data,
> +				enum cfg80211_bss_frame_type ftype,
> +				const u8 *bssid, u64 tsf, u16 capability,
> +				u16 beacon_interval, const u8 *ie, size_t ielen,
> +				struct cfg80211_bss *trans_bss,
> +				gfp_t gfp)

I guess this should now be static too.

> -/* cfg80211_inform_bss_width_frame helper */
> +void proc_mbssid_data(struct wiphy *wiphy,
> +		      struct cfg80211_inform_bss *data,
> +		      enum cfg80211_bss_frame_type ftype,
> +		      const u8 *bssid, u64 tsf, u16 capability,
> +		      u16 beacon_interval, const u8 *ie, size_t ielen,
> +		      struct cfg80211_bss *trans_bss,
> +		      gfp_t gfp)
> +{
> +	const u8 *pos, *subelement, *new_ie, *new_bssid, *mbssid_end_pos;
> +	const u8 *tmp, *mbssid_index_ie;
> +	size_t subie_len, new_ie_len;

"proc" is a really bad prefix for anything in Linux ...

> +	bool is_beacon = false;
> +
> +	if (ftype == CFG80211_BSS_FTYPE_BEACON)
> +		is_beacon = true;

You can roll this into a single line :-)

> +	while (pos < ie + ielen + 2) {
> +		tmp = cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, pos,
> +				       ielen - (pos - ie));
> +		if (!tmp)
> +			break;
> +
> +		mbssid_end_pos = tmp + tmp[1] + 2;
> +		if (tmp[1] > 3) {
> +			subelement = tmp + 3;
> +			subie_len = subelement[1];
> +			while (subelement < mbssid_end_pos) {
> +				if (subelement[0] != 0) {
> +					/* not a BSS profile */
> +					subelement += subelement[1] + 2;
> +					continue;
> +				}
> +
> +				/* found a bss profile */
> +				mbssid_index_ie = cfg80211_find_ie(
> +						WLAN_EID_MULTI_BSSID_IDX,
> +						subelement + 2, subie_len);
> +				if (!mbssid_index_ie) {
> +					subelement += subelement[1] + 2;
> +					continue;
> +				}
> +
> +				new_bssid = gen_new_bssid(bssid, tmp[2],
> +							  mbssid_index_ie[2],
> +							  gfp);
> +				new_ie_len = calculate_new_ie_len(ie, ielen,
> +								  subelement +
> +								  2,
> +								  subie_len);
> +				new_ie = gen_new_ie(ie, ielen, subelement + 2,
> +						    subie_len, new_ie_len,
> +						    is_beacon, gfp);
> +				if (!new_ie) {
> +					subelement += subelement[1] + 2;
> +					continue;
> +				}
> +
> +				memcpy((u8 *)&capability, subelement + 2, 2);
> +				cfg80211_inform_single_bss_data(wiphy, data,
> +								ftype,
> +								new_bssid, tsf,
> +								capability,
> +								beacon_interval,
> +								new_ie,
> +								new_ie_len,
> +								trans_bss,
> +								gfp);

more allocation/refcounting issues here.

> +	tmp = cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen);
> +	if (tmp)
> +		mbssid_present = true;
> +
> +	res = cfg80211_inform_single_bss_data(wiphy, data, ftype, bssid, tsf,
> +					      capability, beacon_interval, ie,
> +					      ielen, NULL, gfp);
> +	if (!mbssid_present)
> +		return res;
> +
> +	/* process each non-transmitting bss */
> +	if (tmp[1] == 1)
> +		return res;
> +
> +	proc_mbssid_data(wiphy, data, ftype, bssid, tsf, capability,
> +			 beacon_interval, ie, ielen, res, gfp);

Having the == 1 check there seems really a bit strange - why not just
let the other thing iterate and do nothing?

There's also a bit of a problem here with the return value now, I
guess.

>  	spin_lock_bh(&rdev->bss_lock);
>  	if (!list_empty(&bss->list)) {
> +		if (!list_empty(&bss->nontrans_list)) {
> +			list_for_each_entry_safe(nontrans_bss, tmp,

same as above

johannes
