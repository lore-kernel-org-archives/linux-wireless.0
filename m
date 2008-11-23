Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48416 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbYKWJTS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Nov 2008 04:19:18 -0500
Subject: Re: [PATCH 1/2] mac80211: add suspend/resume callbacks
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1227415286-30179-2-git-send-email-me@bobcopeland.com> (sfid-20081123_054218_217354_D63E2DF4)
References: <1227415286-30179-2-git-send-email-me@bobcopeland.com>
	 (sfid-20081123_054218_217354_D63E2DF4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UVMxcf8DF4HxbYj/gxXx"
Date: Sun, 23 Nov 2008 10:19:13 +0100
Message-Id: <1227431953.3599.37.camel@johannes.berg> (sfid-20081123_101925_614222_2A5CF628)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UVMxcf8DF4HxbYj/gxXx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-22 at 23:41 -0500, Bob Copeland wrote:
> This patch introduces suspend and resume callbacks to mac80211, allowing
> mac80211 to quiesce its state (bringing down interfaces, removing keys, e=
tc)
> in preparation for suspend.  The driver is responsible for calling
> ieee80211_notify_mac with the appropriate option from its suspend/resume
> hook.

Thanks! Looks pretty good already, a few comments:

> +void __ieee80211_suspend(struct ieee80211_hw *hw)
> +{
> +	struct ieee80211_local *local =3D hw_to_local(hw);
> +	struct ieee80211_sub_if_data *sdata;
> +	struct ieee80211_if_init_conf conf;
> +	struct sta_info *sta;
> +
> +	printk(KERN_DEBUG "mac80211: suspending\n");
> +
> +	rtnl_lock();
> +
> +	flush_workqueue(local->hw.workqueue);
> +
> +	/* disable aggregation and notify that STAs are going away */

I think this should run through interfaces twice, in the first run to
remove keys, then remove stas and then in the second run remove the
interfaces, because otherwise you may be having keys left when the sta
for which the key was has been removed.

> +	/* remove all interfaces */
> +	list_for_each_entry(sdata, &local->interfaces, list) {
> +		ieee80211_disable_keys(sdata);

This needs to take care that the interface is actually up and not a
monitor/ap-vlan interface (those we don't tell the driver about)

> +	/* add interfaces */
> +	list_for_each_entry(sdata, &local->interfaces, list) {
> +	=09
> +		conf.vif =3D &sdata->vif;
> +		conf.type =3D sdata->vif.type;
> +		conf.mac_addr =3D sdata->dev->dev_addr;
> +		res =3D local->ops->add_interface(hw, &conf);
> +
> +		ieee80211_enable_keys(sdata);

Similarly here, make sure the interface is actually up and re-enable the
keys only after adding the stas back.

> +	/* setup RTS and frag thresholds */
> +	if (local->ops->set_rts_threshold)
> +		local->ops->set_rts_threshold(hw, local->rts_threshold);
> +
> +	if (local->ops->set_frag_threshold)
> +		local->ops->set_frag_threshold(hw,=20
> +			local->fragmentation_threshold);

Heh, I didn't even think of those.

What were you thinking of when you said something is missing? I can't
think of anything right now. And what warnings do you get?

Resume definitely needs to defer to schedule_work(), I think, but that's
a trivial change.

johannes

--=-UVMxcf8DF4HxbYj/gxXx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJKSAMAAoJEKVg1VMiehFYbVAQAMUiXQkAntYkGn08W8XO1jAA
1Ekhdyk5CGgMaXGH2O/n0ZY0YjKPcOonJO0hOelTTXNprG8i976kGQfVG06zIs9u
XDI/6gyS05fmdl45mTxkyYHnR8BRMzD6+JJafVB/Qak33eA69lQw76L0BVpM8Er1
zHvuHVRKzRg9k4eQbpESPiKBD4CYAr659P8XAhJUPtdAogciQR5tkeMhnQICG7VW
WAa7RH3GKab9sMNhQByu1Ji7rKQSLoESH186aq2P6fRKAbfMh97KUQQxc4fpPDb9
hjTDJFHsnoPPQ/170sTPhUfdYD/r86j/AocVkicl5cFEv9sq4wbGQWF2Rmjt7AQk
oo7K0toGh+2pl5POfDgN16ntbW3N3UOjKus8qWelUOwJcMqTncAEBPeo9NvJP8EH
CmPf4DxML1so8J5O1+c+2Px1BSZBxZof65hI4HsgRWVVCyuoHRiooK6/mXLawkOE
i0/DRxPsWDlEB9Bt81S3AIk79bOOpp3By2sWIB+mykYyX7S9Er7WftUtANgNQNeU
jM8m/iV3Q10TBF3sIwRebn2/Fc5Zh/t9vabz1Xt3mZbYY/kUpjDGin7XeFO34hMA
yxdcKPh0GCEzeBp+T3KBpG3dzaUtFJrGEbxlPeFb8CUkR8/W3gQ0gvqbiyjhieDJ
OIPvsNefyyBScXLZts2d
=l9Li
-----END PGP SIGNATURE-----

--=-UVMxcf8DF4HxbYj/gxXx--

