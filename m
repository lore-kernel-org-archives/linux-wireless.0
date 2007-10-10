Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbXJJO6v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 10:58:51 -0400
Subject: Re: [PATCH] libertas: automatically re-associate
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <200710100943.33106.hs4233@mail.mn-solutions.de>
References: <200710091404.31491.hs4233@mail.mn-solutions.de>
	 <200710091713.35595.hs4233@mail.mn-solutions.de>
	 <1191944257.20014.3.camel@localhost.localdomain>
	 <200710100943.33106.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 10 Oct 2007 10:58:58 -0400
Message-Id: <1192028338.9739.28.camel@localhost.localdomain> (sfid-20071010_155856_793154_8ABB5F3D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-10-10 at 09:43 +0200, Holger Schurig wrote:
> > > Yes, with a HZ/4 rate.
> >
> > I don't care how _fast_ it tries to reassociate.  I care that
> > it doesn't give up after some amount of time.
> 
> And I don't want that the driver get's stuck after some arbitrary 
> time. *NO OTHER DRIVER* that I know of get's stuck. The current 
> libertas code has actually a built-in denial of service attack.
> 
> Libertas isn't just used in the OLPC, where can make sure some 
> userspace tools does the job. I'll using libertas in PDA like 

I have personally used it on platforms that are !OLPC.  Please don't
assume that I only care about libertas on OLPC.

> devices, which used to have some HERMES I or HERMES II chips and 
> have to switch to some other CF card because you can't buy CF 
> cards with those chips any more. And on those device you can't 
> just arbitrarily change the rest of the firmware.
> 
> So, at least in the no encryption & WEP obfuscation mode a WLAN 
> driver should work without special user space software, because 
> that's how real-life dictates the operation.

I won't throw a hissy fit over the reassociation patch as long as it
only tries this in open & WEP situations where a supplicant is not
necessary.  That means you cannot simply requeue an association in
libertas_mac_event_disconnected(), but you should check the association
request and not requeue if:

1) the assoc request's mode is ad-hoc (is there a point to retrying
assoc in adhoc?)
2) the assoc request has secinfo->WPAenabled || secinfo->WPA2enabled
3) the assoc request has WPA mcast or unicast keys set
4) the assoc request has a wpa_ie_len > 0

so in libertas_mac_event_disconnected() it should to be something like
the following:

if (adapter->pending_assoc_req) {
    if (test_bit(ASSOC_FLAG_MODE, &assoc_req->flags))
        if (assoc_req->mode != IW_MODE_INFRA)
            goto done;

    if (test_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags))
        if (assoc_req->secinfo.WPAenabled ||assoc_req->secinfo.WPA2enabled)
            goto done;

    if (test_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc_req->flags))
        if (assoc_req->wpa_mcast_key.len)
            goto done;

    if (test_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc_req->flags))
        if (assoc_req->wpa_ucast_key.len)
            goto done;

    if (test_bit(ASSOC_FLAG_WPA_IE, &assoc_req->flags))
        if (assoc_req->wpa_ie_len > 0)
            goto done;

    cancel_delayed_work(&priv->assoc_work);
    queue_delayed_work(priv->work_thread,
            &priv->assoc_work, HZ / 4);

done:
    ;
}

Dan

> And, as said, otherwise you have a denial of service scenario.
> 
> 
> > That's fine.  The drivers should _not_ be trying to handle all
> > roaming cornercases themselves.
> 
> Either the driver or the firmware should handle all corner cases. 
> With a HERMES II chip and a wlags49_h2_cs.ko driver, I can 
> nicely roam with WPA+wpa_supplicant, and also with plain WEP 
> (and no wpa_supplicant).
> 
> I see no technical reason why libertas shouldn't be able to do 
> the same and behave like all other FULLMAC drivers.
> 
> 
> > Userspace must come into the equation at some point, especially
> > with WPA!!
> 
> I don't see that userspace *MUST* come into the equation at some 
> point. If it *WISHES* to come into the equation: nothing hinders 
> it. Running "iwevent" while killing the station at the AP yields 
> these events:
> 
> 10:38:43.139777   eth1     New Access Point/Cell 
> address:Not-Associated
> 10:38:43.389217   eth1     Scan request completed
> 10:38:45.161671   eth1     New Access Point/Cell 
> address:00:1B:53:11:E2:B0
> 

