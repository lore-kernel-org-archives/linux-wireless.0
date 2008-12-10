Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38380 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbYLJRTY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 12:19:24 -0500
Subject: Re: [RFC] b43: rework rfkill code
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	hmh@hmh.eng.br
In-Reply-To: <1228927898.19553.164.camel@violet.holtmann.net>
References: <20081210150935.GA10927@srcf.ucam.org>
	 (sfid-20081210_160955_698729_A777A57C)  <1228922997.15837.6.camel@johannes.berg>
	 <1228927898.19553.164.camel@violet.holtmann.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-J5lIEL7fB3VOTTnJb5RW"
Date: Wed, 10 Dec 2008 18:18:49 +0100
Message-Id: <1228929529.15837.34.camel@johannes.berg> (sfid-20081210_181928_441073_38D73A3E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-J5lIEL7fB3VOTTnJb5RW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[warning: this is going to be a long mail and will tell you why and how
I think rfkill needs to be rewritten]

On Wed, 2008-12-10 at 17:51 +0100, Marcel Holtmann wrote:

> if you figured out on how to do it the best way, then let me know,
> because I have to do the same thing for Bluetooth.

I'd suggest to start by rewriting rfkill to be not such a mess to use.

We really need to disentangle the state tracking rfkill does. People
have said this a million times before, but nobody cares: drivers need to
register hard-blocked and get soft-block states independently, not in a
single enum; API for drivers needs to be, above all, EASY to use.

For mac80211, we really need to register an rfkill structure for each
physical device that mac80211 knows about. Drivers would not be allowed
to get access to this structure, because the toggle_radio() callback is
assigned to a mac80211 function that calls the driver's ->config()
callback and, at some point, also disallows configuring interfaces that
belong to a device that is rfkilled.

To properly implement this, however, we need to disentangle rfkill
states and provide just a single API function to change the state:

rfkill_hw_kill(struct rfkill *rfkill, bool killed);

this would be shadowed by mac80211 with
	ieee80211_hw_rfkill(struct ieee80211_hw *hw, bool killed)
so mac80211 knows about hard-kills too, since they don't call
->toggle_radio() obviously.

I know what you're thinking at this point, but hear me out. This is
another thing where I think rfkill's design is fundamentally wrong. If
you're not thinking anything, hear me out anyway :)


Let's take a step back here and analyse what we really have and need:

 * we have devices with a plethora of rfkill setups:
   1) devices disappear from the bus (not handled here, not possible
      either)
   2) devices have hard kill button that just disables the radio
      (need to know about this so users aren't left in the dark)
   3) devices have soft kill buttons that just notify the driver
   4) soft kill switches that work through other input methods (ACPI
      comes to mind, but anything is possible)
 * we have various ways to kill the radio:
   1) like above
   2) through platform methods (toshiba ACPI I think?)
   3) through the driver only

The last two cases only differ in the radios that the button is supposed
to apply to, but this is more of a policy decision.

The point where I think rfkill's design is totally wrong is that it
intimately ties this software kill from case three to the rfkill
structure as well.

Instead, we should come to accept that this is just a button as well. A
button, however, that is *by default* tied to a particular radio.
Therefore, drivers for devices that provide such buttons, should, in my
opinion, register an rfkill button driver that
 a) by default is tied to their hardware by a pointer to the rfkill
    struct for the hardware, but this could be possible to override in
    sysfs like LEDs are, if you want the button to really kill all
    radios
 b) serves as input to the rfkill subsystem which will then look up the
    right rfkill struct(s) and ask them to kill the radio

This would add new API for a button, but again only a single function,
something like
	rfkill_button_update(struct rfkill_button *btn, bool killed)


Finally, rfkill-input will boil down to just registering a software
button that happens to control all radios by default, by setting the
controlled rfkill struct to NULL.


johannes

--=-J5lIEL7fB3VOTTnJb5RW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJP/n1AAoJEKVg1VMiehFYqA0P/0yL+uXeLNcWkE/8Bawz6KMW
PLfK03ixGfjUwm83xtHGrsuoXEyDTfMdHNH0LLNkbE8+H7XfH0AjYbNAkBthhyhg
aZ/BJKvPfNF5unPrdBYb53Rb1gkGRjVUTpZIiJQZoI4na/cnmfJvLkw33Piv8juF
ox1h/PrFeuD1grfwVcOp2dtnjZrQQ2pvtpHrFyM3TnCVfin9YHcJQCFxcbJ5LmHX
YP9QpnOZ27VA6Ne8yhB5sGqDnqBEaIMeTLH97bqTms4eBL6HiqFOW9vZMbsJIYA7
1bYkm/bC/lrzCY5X3K/J2Qa2855ZiDeXFLWr1T/hWmkUyEX3kenUiVzHkh6YBe7Q
8kMZ0pobkoZzGdBvSZyNGx7EuIKu+h9g2n27EHJLB2SMDpdmmDn4cSKSe13Elcbe
6zH1zoIb9HZgmXfaWu13cqORgb/ZZ++HQP4DatmW8KrTePnwjC/XyDdpnCBdLbQe
vJNDBoUFCCUizDtZqzXOwpyijPFZLcLtyRLnNXbkt0TUG3/K1fiLJ3xAPImfpHhs
1xkEZMf7Y72DqkGgj0JSclsJUgi+ni3W5pDd4LNlB+A9Eb4GF74D9h3cFSVvjWEu
AxXRCfjYuw1DI/z7V6vf6ukFzuc5tk18GQBsZlQAsayXcHkx2JZM+ESedDkY0+rv
RXJALtrtiAkQpCHCuCWF
=tRN5
-----END PGP SIGNATURE-----

--=-J5lIEL7fB3VOTTnJb5RW--

