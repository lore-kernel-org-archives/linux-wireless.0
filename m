Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:52334 "EHLO
        li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752699AbcJNNi0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Oct 2016 09:38:26 -0400
Date: Fri, 14 Oct 2016 16:38:21 +0300
From: Jouni Malinen <j@w1.fi>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        linux-wireless@vger.kernel.org, hostap@lists.infradead.org,
        yangzy@marvell.com, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        lihz <lihz@marvell.com>
Subject: Re: [PATCH] nl80211: add key management offload feature
Message-ID: <20161014133821.GA8928@w1.fi> (sfid-20161014_153830_420591_FFBD74B7)
References: <1474973796-1873-1-git-send-email-akarwar@marvell.com>
 <1474973796-1873-2-git-send-email-akarwar@marvell.com>
 <df801822-f23d-e7e3-15c2-1849370fd01f@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <df801822-f23d-e7e3-15c2-1849370fd01f@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 27, 2016 at 01:24:24PM +0200, Arend Van Spriel wrote:
> On 27-9-2016 12:56, Amitkumar Karwar wrote:
> > From: lihz <lihz@marvell.com>
> 
> minor thing. Could you use another prefix iso 'nl80211:'. That has
> different expectation for me at least, ie. changes in nl80211 api, but
> this patch is for hostap repo so 'hostap:' or 'wpa_supp:' would be
> better fit here.

Well.. That's for the context of linux-wireless. As far as the actual
commit in hostap.git and the hostap mailing list (now with the correct
address) is concerned, "nl80211:" is the correct prefix to use in the
commit message.

> > diff --git a/src/common/defs.h b/src/common/defs.h
> > @@ -148,7 +148,9 @@ enum wpa_alg {
> > -	WPA_ALG_BIP_CMAC_256
> > +	WPA_ALG_BIP_CMAC_256,
> > +	WPA_ALG_PMK_R0,
> > +	WPA_ALG_PMK_R0_NAME,

I guess I could kind of understand WPA_ALG_PMK_R0 as a new "algorithm"
since this is also used to configure keys, but PMK-R0-Name is going
pretty far in that regard. It most certainly is not a key..

> >  #define WLAN_CIPHER_SUITE_SMS4		0x00147201
> > +#define WLAN_CIPHER_SUITE_PMK		0x00147202
> > +#define WLAN_CIPHER_SUITE_PMK_R0	0x00147203
> > +#define WLAN_CIPHER_SUITE_PMK_R0_NAME	0x00147204

As noted previously, it is not acceptable to assign new AKMs from
someone else's OUI. Once there is consensus on what values are needed, I
can assign the needed values from the 00:13:74 OUI.

> > diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
> > @@ -2675,21 +2675,34 @@ static int wpa_driver_nl80211_set_key(const char *ifname, struct i802_bss *bss,
> > -#ifdef CONFIG_DRIVER_NL80211_QCA
> > -	if (alg == WPA_ALG_PMK &&
> > -	    (drv->capa.flags & WPA_DRIVER_FLAGS_KEY_MGMT_OFFLOAD)) {
> > -		wpa_printf(MSG_DEBUG, "%s: calling issue_key_mgmt_set_key",
> > -			   __func__);
> > -		ret = issue_key_mgmt_set_key(drv, key, key_len);
> > -		return ret;
> > +
> > +	if ((alg == WPA_ALG_PMK || alg == WPA_ALG_PMK_R0 ||
> > +	     alg == WPA_ALG_PMK_R0_NAME) &&

I understand PMK as a new key that is being configured. For FT, I'm not
completely sure about PMK-R0 as a separate algorithm and especially not
about using this interface for setting PMK-R0-Name which is tightly
coupled name with a specific PMK-R0 and not something that one would
configure separately.

> > diff --git a/src/drivers/driver_nl80211_event.c b/src/drivers/driver_nl80211_event.c
> > @@ -2065,18 +2065,6 @@ static void do_process_drv_event(struct i802_bss *bss, int cmd,
> >  	wpa_printf(MSG_DEBUG, "nl80211: Drv Event %d (%s) received for %s",
> >  		   cmd, nl80211_command_to_string(cmd), bss->ifname);
> >  
> > -	if (cmd == NL80211_CMD_ROAM &&
> > -	    (drv->capa.flags & WPA_DRIVER_FLAGS_KEY_MGMT_OFFLOAD)) {
> > -		/*
> > -		 * Device will use roam+auth vendor event to indicate
> > -		 * roaming, so ignore the regular roam event.
> > -		 */
> > -		wpa_printf(MSG_DEBUG,
> > -			   "nl80211: Ignore roam event (cmd=%d), device will use vendor event roam+auth",
> > -			   cmd);
> > -		return;
> > -	}

It is not going to be acceptable to break the existing mechanism that
uses QCA vendor specific commands/events. In other words, the new
extensions need to be done in a backwards compatible manner that allow
both to work based on driver capabilities.

> > diff --git a/src/rsn_supp/wpa_ft.c b/src/rsn_supp/wpa_ft.c
> > @@ -37,6 +37,10 @@ int wpa_derive_ptk_ft(struct wpa_sm *sm, const unsigned char *src_addr,
> > +	wpa_sm_set_key(sm, WPA_ALG_PMK_R0, NULL, 0, 1, NULL,
> > +		       0, sm->pmk_r0, PMK_LEN);
> > +	wpa_sm_set_key(sm, WPA_ALG_PMK_R0_NAME, NULL, 0, 1, NULL,
> > +		       0, sm->pmk_r0_name, WPA_PMK_NAME_LEN);

This looks quite bad. I don't think I can really support two separate
nl80211 commands to set a PMK-R0 and the matching PMK-R0-Name, i.e.,
this should really be a single (atomic) operation.

-- 
Jouni Malinen                                            PGP id EFC895FA
