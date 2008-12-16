Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:43898 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbYLPV4l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 16:56:41 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Memory errors from p54usb
Date: Tue, 16 Dec 2008 22:56:36 +0100
Cc: wireless <linux-wireless@vger.kernel.org>, Jouni Malinen <j@w1.fi>
References: <49466F56.6060805@lwfinger.net> <200812162029.22491.chunkeey@web.de> <49481CCC.1030903@lwfinger.net>
In-Reply-To: <49481CCC.1030903@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200812162256.36605.chunkeey@web.de> (sfid-20081216_225646_004611_F25BBFEC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 16 December 2008 22:25:32 Larry Finger wrote:
> Christian Lamparter wrote:
> >=20
> > and when the traffic dies down, does iwlist wlanX still give you a
> > reasonable output,
>=20
> Yes - the AP scan is normal.
well, so the receiver sort of works.
> >=20
> > or has NM some sort of cli interface (e.g: wpa_cli ) because I woul=
d
> > like to see what
> >=20
> > the station supplicant is doing...?
>=20
> I switched to ifup/down control. It seems that wpa_supplicant is gett=
ing
> confused. Attached is a -ddd dump.
>=20
> BTW, dmesg does not show anything - nothing is logged. Some of those
> wpa_supplicant reconnection events did not kill the connection, but e=
ventually
> it does not recover. I did the same test with rtl8187 and found the s=
ame kind of
> sequences such as
>=20
> EAPOL: SUPP_PAE entering state CONNECTING
> EAPOL: txStart
> WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=3D1 len=3D0)
> ^CCTRL-EVENT-TERMINATING - signal 2 received
> Removing interface wlan1
> State: 4WAY_HANDSHAKE -> DISCONNECTED
> wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
> WEXT: Operstate: linkmode=3D-1, operstate=3D5
> wpa_driver_wext_deauthenticate
> No keys have been configured - skip key clearing
> EAPOL: External notification - portEnabled=3D0
> EAPOL: SUPP_PAE entering state DISCONNECTED
> EAPOL: SUPP_BE entering state INITIALIZE
> EAPOL: External notification - portValid=3D0
> wpa_driver_wext_set_wpa
> wpa_driver_wext_set_drop_unencrypted
> wpa_driver_wext_set_countermeasures
> WEXT auth param 4 value 0x0 - ioctl[SIOCSIWAUTH]: Operation not suppo=
rted
> No keys have been configured - skip key clearing
>=20
> When these happen, the flood ping is interrupted with rtl8187 but it =
always
> recovers. I don't remember this behavior from earlier, but it still h=
appens with
> 2.6.25 - it doesn't seem to be a mac80211 regression.
>=20
> Larry

well, looks like TKIP countermeasures after all....

The question is how to "debug" it...

jm, are you aware of any compatibility problems or
regression between broadcom APs and wpa_supplicant
with WPA TKIP?

I just added the extract of wpa_supplicant logs that looked important:

WPA: Invalid EAPOL-Key MIC when using TPTK - ignoring TPTK
WPA: Could not verify EAPOL-Key MIC - dropping packet
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11043 ([UP][RUNNING][LOWER_UP]=
)
[...]
WPA: Invalid EAPOL-Key MIC when using TPTK - ignoring TPTK
WPA: Could not verify EAPOL-Key MIC - dropping packet
[...]
Authentication with XX:XX:XX:XX:XX:b1 timed out.
Added BSSID XX:XX:XX:XX:XX:b1 into blacklist
[...]
WPA: Invalid EAPOL-Key MIC when using TPTK - ignoring TPTK
WPA: Could not verify EAPOL-Key MIC - dropping packet
EAPOL: startWhen --> 0
[...]
Authentication with XX:XX:XX:XX:XX:b1 timed out.
BSSID XX:XX:XX:XX:XX:b1 blacklist count incremented to 2
[...]
1: XX:XX:XX:XX:XX:b1 ssid=3D'Larry' wpa_ie_len=3D26 rsn_ie_len=3D0 caps=
=3D0x11
=C2=A0 =C2=A0skip - blacklisted
[...]
No APs found - clear blacklist and try again
Removed BSSID 00:00:00:00:00:00 from blacklist (clear)
Removed BSSID XX:XX:XX:XX:XX:b1 from blacklist (clear)
[...]
State: DISCONNECTED -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=3D-1, operstate=3D5
wpa_driver_wext_associate
wpa_driver_wext_associate: assoc failed because set_mode failed
Association request to the driver failed
[...]
WPA: Invalid EAPOL-Key MIC when using TPTK - ignoring TPTK
WPA: Could not verify EAPOL-Key MIC - dropping packet
[.......]

Regards,
	Chr
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
