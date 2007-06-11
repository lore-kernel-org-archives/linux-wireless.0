Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27373 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbXFKEMc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 00:12:32 -0400
Subject: Re: [PATCH 2/3] mac80211: IEEE802.11e/WMM TS management and DLS  support
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <1181157532.3398.20.camel@johannes.berg>
References: <20070606082223.GA28658@mail.intel.com>
	 <1181157532.3398.20.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 11 Jun 2007 12:11:29 +0800
Message-Id: <1181535089.3042.72.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-06-06 at 21:18 +0200, Johannes Berg wrote:
> Some nitpicking below :)
> 
> > +		if (dls_link_status(local, skb->data) == DLS_STATUS_OK){
> 
> missing space there, but maybe the line is too long with it?

Yup. The line happens to be 80 originally before Michael pointed a bug
here. I forgot to add the space back after that.

> > +					case WIFI_OUI_STYPE_WMM_TSPEC:
> > +						if (elen != 61) {
> > +							printk(KERN_ERR "Wrong "
> > +							       "TSPEC size.\n");
> > +							break;
> 
> That printk should be rate limited.

Umm, I followed the same way as other MLME parsing functions ie.
ieee80211_rx_mgmt_assoc_resp. It seems they also didn't rate limit these
cases. This only happens on broken APs. Do you think we really need to
rate limit here?

> > +					default:
> > +						//printk(KERN_ERR "Unsupported "
> > +						//       "WiFi OUI %d\n", pos[4]);
> > +						break;
> 
> And maybe that should be there for the debug case (rate limited as
> well)?

I got a lot of this message during my testing. The APs use some
(private) OUIs we don't support now. I guess there will be quite a lot
messages even if we rate limit here.

> > +		case WLAN_EID_TSPEC:
> > +			if (elen != 55) {
> > +				printk(KERN_ERR "Wrong TSPEC size.\n");
> > +				break;
> 
> Ditto.
> 
> > +	if (ifsta->ts_data[tsid][index].status == TS_STATUS_UNUSED) {
> > +		printk(KERN_DEBUG "%s: Tring to delete an ACM disabled TS "
> 
> typo "Tring".

Thanks!

> Can this be invoked by somebody requesting you to do it? If so it should
> be rate limited as well. I haven't quite understood the code flow here
> yet.
> 
> > +	if (ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems)
> > +	    == ParseFailed) {
> > +		printk(KERN_DEBUG "%s: failed to parse TSPEC\n", dev->name);
> > +		return;
> 
> Wants rate limiting too, afaict.

mac80211 doesn't rate limit ParseFailed cases in other parts. ie.
ieee80211_rx_mgmt_assoc_resp, etc.

> > +	printk(KERN_DEBUG "Receive DLS request from "
> > +	       "%02X:%02X:%02X:%02X:%02X:%02X\n",
> > +	       src[0], src[1], src[2], src[3], src[4], src[5]);
> 
> Again?

This management packet is sent from the AP. Not from the STA user
requests DLS connection directly. So can I compare this to the following
line in ieee80211_rx_mgmt_assoc_resp().

printk(KERN_DEBUG "%s: RX %sssocResp from " MAC_FMT " (capab=0x%x "
               "status=%d aid=%d)\n",
               dev->name, reassoc ? "Rea" : "A", MAC_ARG(mgmt->sa),
               capab_info, status_code, aid);

> > +	if (ieee802_11_parse_elems(mgmt->u.action.u.dls_req.variable,
> > +				   len - baselen, &elems) == ParseFailed) {
> > +		printk(KERN_ERR "DLS Parse support rates failed.\n");
> > +		return;
> 
> and again?

See above.

> > +	printk(KERN_DEBUG "Receive DLS response from "
> > +	       "%02X:%02X:%02X:%02X:%02X:%02X\n",
> > +	       src[0], src[1], src[2], src[3], src[4], src[5]);
> > +
> > +	if (mgmt->u.action.u.dls_resp.status_code) {
> > +		printk(KERN_ERR "DLS setup refused by peer. Reason %d\n",
> > +		       mgmt->u.action.u.dls_resp.status_code);
> > +		return;
> > +	}
> 
> I suppose these are ok since we're not going to request DLS a lot,
> right?

Yup.

> > +	printk(KERN_DEBUG "DLS Teardown received from "
> > +	       "%02X:%02X:%02X:%02X:%02X:%02X. Reason %d\n",
> > +	       src[0], src[1], src[2], src[3], src[4], src[5],
> > +	       mgmt->u.action.u.dls_teardown.reason_code);
> > +
> > +	dls = dls_info_get(local, src);
> > +	if (dls)
> > +		sta_info_free(dls, 0);
> 
> Do we really want to free the sta info here? Shouldn't we have a sta
> info item for the DLS peer anyway, and then we can't free it here but
> rather reset the DLS status?

Yes we can do this. But free it here helps to shrink the hash table
size. The problem is: the original sta_info doesn't a status -- if a
sta_info appears in the hash table, it is active; otherwise it is not.
But since DLS requires setup stage, I added the status code to
distinguish setuping and active. But for inactive state, we can either
set the DLS status to inactive or remove the sta_info completely. Since
normally a DLS connection won't be setup and teardown that often, I
select to free the sta_info to indicate it as inactive.

> > +		if (len < 24 + 4) {
> > +			printk(KERN_DEBUG "%s: too short (%zd) QoS category "
> > +			       "frame received from " MAC_FMT " - ignored\n",
> > +			       dev->name, len, MAC_ARG(mgmt->sa));
> 
> rate limit.

See the following code in ieee80211_rx_mgmt_auth()

if (len < 24 + 6) {
                printk(KERN_DEBUG "%s: too short (%zd) authentication
frame "
                       "received from " MAC_FMT " - ignored\n",
                       dev->name, len, MAC_ARG(mgmt->sa));
                return;
        }

> > +			printk(KERN_ERR "%s: unsupported QoS action code %d\n",
> > +			       dev->name,
> > +			       mgmt->u.action.u.wme_action.action_code);
> 
> rate limit.

There is no other QoS action code not supported by mac80211. If we see
any, we can fix it.

> > +			printk(KERN_DEBUG "%s: too short (%zd) DLS category "
> > +			       "frame received from " MAC_FMT " - ignored\n",
> > +			       dev->name, len, MAC_ARG(mgmt->sa));
> 
> ditto.

see above.
> 
> > +			printk(KERN_ERR "%s: unsupported DLS action code %d\n",
> > +			       dev->name, mgmt->u.action.u.dls_req.action_code);
> 
> ditto.

see above.

> > +struct sta_info *dls_info_get(struct ieee80211_local *local, u8 *addr)
> 
> Ok, I don't understand the DLS info stuff. Basically it's a sta info,
> but why not just do sta_info_get() on the regular one and then set the
> dls peer bit?

Do you mean below code instead?

struct sta_info *dls_info_get()
{
	sta = sta_info_get(local, addr);
	if (sta)
		if (sta->dls_sta)
			return sta;
	else
		sta_info_put(sta);
	return NULL;
}

This is not optimized in the (sta && !sta->dls_sta) case.

> > +			if (net_ratelimit())
> > +				printk(KERN_DEBUG "QoS packet throttling\n");
> 
> Hey! :)

Yeah, that's a hot path.

Thanks for your feedbacks!
-yi
