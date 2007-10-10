Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:61277 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743AbXJJNr3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 09:47:29 -0400
Received: by wa-out-1112.google.com with SMTP id v27so234915wah
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2007 06:47:28 -0700 (PDT)
Message-ID: <f6ca9fed0710100647r208b0181xccecf1edd075c635@mail.gmail.com> (sfid-20071010_144801_015794_51401CE5)
Date: Wed, 10 Oct 2007 15:47:27 +0200
From: dragoran <drago01@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: mac80211/iwlwifi + hidden ssids
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20071010130653.GB5962@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <470C9F28.1070803@gmail.com> <20071010130653.GB5962@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/10/07, John W. Linville <linville@tuxdriver.com> wrote:
> On Wed, Oct 10, 2007 at 11:45:12AM +0200, dragoran wrote:
> > Hello,
> > I am unable to connect to a dynamic wep network with hidden ssid using
> > iwl3945 and the lastest fedora 7 kernel (which should have very recent
> > stuff). The problem is that the card never finds the ap. Running
> > wpa_supplicant directly shows "Got scan results xxx bytes" (can't
> > remeber the exact message).
> > While with ipw3945d + ieee80211 it works fine. (NetworkManager does not
> > connect either see http://bugzilla.gnome.org/show_bug.cgi?id=464215 ).
> > I haven't tryed the suggestion there yet because I am not near the
> > network right now.
> > Any idea whats wrong? Does it work for anybody (maybe with other
> > mac80211 drivers)
> > Currently I am not sure whom to blame iwl3945 or mac80211 or both.
>
> Fedora 7 kernels are a little behind (1-2 weeks behind wireless-2.6)
> ATM, so it might be best to handle this at bugzilla.kernel.org.

Ok, will file a bug after collecting more data (wpa_supplicant output).

> F7 _does_ have the kernel patch to probe for hidden SSIDs when
> associating.  What I've found with that patch is that manually
> invoking the wireless tools yields satisfactory results, but that NM
> (which afaik relies on wpa_supplicant) still tends to have problems.
I know I also followed the thread on the nm list but it seems that I
cannot even get a connection with wpa_supplicant started by hand.

> My hunch is that wpa_supplicant (at least how NM configures it)
> is doing something "too smart", but I really don't know.
>
> Do you have control over the AP?  If so, can you temporarily try
> using static WEP or an open configuration so that you can test using
> iwconfig?

no if I had I could do some more testing. but the only thing I can nod
with this ap is to test if it works or not.

the wpa_supplicant.conf I tryed:
-----------
# this driver requires ap_scan=2 mode when using hidden SSIDs
# request driver to take care of AP selection and roaming
ap_scan=2

# enable control interface using UNIX domain sockets
ctrl_interface=/var/run/wpa_supplicant

# you can include one or more network blocks here
network={
    ssid="NETWORKNAME"
    key_mgmt=IEEE8021X
    eap=TTLS
    phase2="auth=MSCHAPV2"
    identity="username"
    password="password"
}
----------------------------------
the exact same config works with the old stack.... should I try to
change the ap_scan value to 1 ?
