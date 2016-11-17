Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:37637 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751194AbcKQHX2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 02:23:28 -0500
Received: by mail-wm0-f43.google.com with SMTP id t79so125293810wmt.0
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2016 23:23:28 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@open-mesh.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        Simon Wunderlich <simon.wunderlich@open-mesh.com>
Subject: Re: [RFC 1/2] ath9k: work around AR_CFG 0xdeadbeef chip hang
Date: Thu, 17 Nov 2016 08:23:22 +0100
Message-ID: <1913827.jKK0T8B8yE@bentobox> (sfid-20161117_082333_070309_4A256F7C)
In-Reply-To: <87wpg3mmc6.fsf@kamboji.qca.qualcomm.com>
References: <20161114144226.15748-1-sven.eckelmann@open-mesh.com> <87wpg3mmc6.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart246563734.JFlX2VBm8b"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart246563734.JFlX2VBm8b
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Mittwoch, 16. November 2016 16:16:42 CET Valo, Kalle wrote:
> Sven Eckelmann <sven.eckelmann@open-mesh.com> writes:
> 
> > From: Simon Wunderlich <simon.wunderlich@open-mesh.com>
> >
> > QCA 802.11n chips (especially AR9330/AR9340) sometimes end up in a state in
> > which a read of AR_CFG always returns 0xdeadbeef. This should not happen
> > when when the power_mode of the device is ATH9K_PM_AWAKE.
> >
> > This problem is not yet detected by any other workaround in ath9k. No way
> > is known to reproduce the problem easily.
> >
> > Signed-off-by: Simon Wunderlich <simon.wunderlich@open-mesh.com>
> > [sven.eckelmann@open-mesh.com: port to recent ath9k, add commit message]
> > Signed-off-by: Sven Eckelmann <sven.eckelmann@open-mesh.com>
> 
> [...]
> 
> > +void ath_hw_hang_work(struct work_struct *work)
> > +{
> > +	struct ath_softc *sc = container_of(work, struct ath_softc,
> > +					    hw_hang_work.work);
> > +
> > +	if (ath_hw_hang_deadbeef(sc))
> > +		goto requeue_worker;
> > +
> > +requeue_worker:
> > +	ieee80211_queue_delayed_work(sc->hw, &sc->hw_hang_work,
> > +				     msecs_to_jiffies(ATH_HANG_WORK_INTERVAL));
> > +}
> 
> The goto doesn't make any sense, either me or the function is missing
> something :)
> 
> 

It is just for the next patch. And yes, could be done differently.

Kind regards,
	Sven
--nextPart246563734.JFlX2VBm8b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJYLVrqAAoJEF2HCgfBJntGvFUP/0xnKmwB2Xhuw1n4S555O6hv
F62CooW3hf+01y/cypyE3TGjz6e7XQ9OBcJ5BSLHvqCK6bxXQG1rLm3ngQgPqQsk
28AGb5SUVtVT6s1hye6IRTuj5ss54MMyWHh9zOek5AziRp/iLr3j0KUz/YAKmBBh
wHP+g05cObwbzYT+PQeCnKCSL3TGGyCre8WYVREjtGO3PXHbNVd+832yLriHo6hv
eFi+9n1dxt/s2ecDcF188i3dASjn9m5ZxCQDK7JK9uN32HLPkfcQLXCAH0yWAw9f
76k9zAm6OPFWwzR7MLsxIougOYtF45ziwLnqdkNi4Is8Y8Wk0GVWqKbuuLycexlK
EkMJRqEr5fURw2vAbzz0mrogYF18Vhix4E/XcJi8+HDY3fL89afZ8agm+EKUoIjG
vFD00EVd3KxhXxfzoy7LpkXo+5DGuDqx3vAHC7/7g2mNpnQtt3ZqS+u3RiIaj9Gc
HpUZw6UveE6Sg7rINIFTy9+fVzDd7YiWGz8bMZujoO7v+7+FjhzcmMpDb92KUWcl
aQWw0M9KaGBIZUYVO6UDzfO6OjkpFRuHcKb7MIER33zyWTIxHSc899259cTEt5uj
9FuciC0MjwsJhO86sS+vQbcN5i+qfO83bgYEt3wFhTXL/hBN1cgpZQ7PktKPjxHK
YIprTy+F2JWzjWn+ouxP
=RhnM
-----END PGP SIGNATURE-----

--nextPart246563734.JFlX2VBm8b--
