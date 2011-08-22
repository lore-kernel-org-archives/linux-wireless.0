Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34475 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab1HVN2w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 09:28:52 -0400
Received: by ewy4 with SMTP id 4so1839853ewy.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2011 06:28:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E525235.7060501@broadcom.com>
References: <20110814121646.GA5188@stt008.linux.site>
	<4E4A5641.4020604@broadcom.com>
	<1313509211.2065.36.camel@dcbw.foobar.com>
	<4E4B9A45.5090507@broadcom.com>
	<4E4CC85A.7010504@broadcom.com>
	<4E4E73F4.4040105@broadcom.com>
	<20110819152140.GA7506@stt008.linux.site>
	<CAKprTDEUVa6ouH92G_8UMo20wYNnrhu76c_XAPYDtbCbRjqdLw@mail.gmail.com>
	<4E52297D.9090301@broadcom.com>
	<20110822112737.GA5936@stt008.linux.site>
	<4E525235.7060501@broadcom.com>
Date: Mon, 22 Aug 2011 15:28:51 +0200
Message-ID: <CAKprTDHO+Hh4g3WjGijDhPtzY5PiqR0GQ_zg8Uw46-qOVXpCRQ@mail.gmail.com> (sfid-20110822_152901_111480_DCE47B8B)
Subject: Re: brcmsmac driver only works when sitting next to the AP
From: =?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>
To: Roland Vossen <rvossen@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	"networkmanager-list@gnome.org" <networkmanager-list@gnome.org>
Content-Type: multipart/mixed; boundary=000e0cd1e2f64e7a9804ab180f1b
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--000e0cd1e2f64e7a9804ab180f1b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

2011/8/22 Roland Vossen <rvossen@broadcom.com>:

>> Moreover, "service network-manager stop" returns "failed" unless I
>> first turn off the wifi led (and so phy0 hard blocked is set as "yes").
>
> Interesting observations. Ok, lets keep this in the back of our minds but
> first focus on the bad scan results.

Okay, jus let me add (attached to this e-mail) the call trace I get
when stopping NM with the wifi LED on.

>>> Can you do a 'rfkill unblock all' to see if that makes a difference ?
>>> It makes no difference. No wifi networks are detected automatically nor
>>> connecting manually to a hidden network is possible (unless I sit next =
to
>>> the AP).
>
> Hmmm, so it seems that rfkill switch functionality is not causing the bad
> scan result.
>
> Can you try to disable Bluetooth (e.g. by temporary blacklisting the
> bluetooth modules) ? Bluetooth operates in the same frequency band as WiF=
i.

I blackisted the module:

root@stt300:~# grep -i blue /etc/modprobe.d/blacklist.conf
blacklist bluetooth

And rebooted. Now I can't see the module loaded:

root@stt300:~# lsmod|grep blu
root@stt300:~#

Bu I still get the same issue:

Aug 22 15:18:08 stt300 anacron[1934]: Normal exit (0 jobs run)
Aug 22 15:18:09 stt300 dbus[1128]: [system] Activating service
name=3D'org.freedesktop.UDisks' (using servicehelper)
Aug 22 15:18:09 stt300 dbus[1128]: [system] Successfully activated
service 'org.freedesktop.UDisks'
Aug 22 15:18:14 stt300 wpa_supplicant[1167]: Failed to initiate AP scan.
Aug 22 15:18:16 stt300 dbus[1128]: [system] Activating service
name=3D'org.gnome.ClockApplet.Mechanism' (using servicehelper)
Aug 22 15:18:16 stt300 dbus[1128]: [system] Successfully activated
service 'org.gnome.ClockApplet.Mechanism'
Aug 22 15:18:24 stt300 dbus[1128]: [system] Activating service
name=3D'org.debian.apt' (using servicehelper)
Aug 22 15:18:27 stt300 AptDaemon: INFO: Initializing daemon
Aug 22 15:18:27 stt300 dbus[1128]: [system] Successfully activated
service 'org.debian.apt'
Aug 22 15:18:44 stt300 wpa_supplicant[1167]: Failed to initiate AP scan.

> Would you happen to know if with kernel 2.6.39, the brcmsmac driver was
> active as well (and not a different driver) ?

I expressely used the brcmsmac because it was newer, easier to setup
than the others... and it's open source :-)

Greetings,

--=20
Camale=F3n

--000e0cd1e2f64e7a9804ab180f1b
Content-Type: text/plain; charset=US-ASCII; name="nm_shutdown_call_trace.txt"
Content-Disposition: attachment; filename="nm_shutdown_call_trace.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_grnhetx90

WyA3MjAwLjc5NjE0OV0gSU5GTzogdGFzayBOZXR3b3JrTWFuYWdlcjoyNjAyIGJsb2NrZWQgZm9y
IG1vcmUgdGhhbiAxMjAgc2Vjb25kcy4KWyA3MjAwLjc5NjE2Ml0gImVjaG8gMCA+IC9wcm9jL3N5
cy9rZXJuZWwvaHVuZ190YXNrX3RpbWVvdXRfc2VjcyIgZGlzYWJsZXMgdGhpcyBtZXNzYWdlLgpb
IDcyMDAuNzk2MTcyXSBOZXR3b3JrTWFuYWdlciAgRCAwMDAwMDAwMSAgICAgMCAgMjYwMiAgICAg
IDEgMHgwMDAwMDAwNApbIDcyMDAuNzk2MTg4XSAgZjU4OTc2YjAgMDAyMDAwODIgMDAwMDA2NDYg
MDAwMDAwMDEgMDAwMDAwMDAgMDAwMDAwMDAgZjRlY2RhZjQgYzE0ODc5ODAKWyA3MjAwLjc5NjIx
M10gIGY1ODk3ODVjIDAwMDAwNjQ2IGMxNDg3OTgwIGY1ODk3NmIwIGMxNDg3OTgwIGMxNDg3OTgw
IDAwMDAwMDAyIDAwMjAwMDAyClsgNzIwMC43OTYyMzZdICAwMDAwMDBmZCBmNGVjZGIzOCA3ZmZm
ZmZmZiAwMDAwMDAwMiBmNGVjZGIyYyBjMTJhZDg3NCBmNGVjZGIzYyBjMTJhY2IwNgpbIDcyMDAu
Nzk2MjU5XSBDYWxsIFRyYWNlOgpbIDcyMDAuNzk2Mjg0XSAgWzxjMTJhZDg3ND5dID8gX3Jhd19z
cGluX2xvY2tfaXJxKzB4Yi8weDE2ClsgNzIwMC43OTYyOThdICBbPGMxMmFjYjA2Pl0gPyB3YWl0
X2Zvcl9jb21tb24rMHhjNy8weGQxClsgNzIwMC43OTYzMTJdICBbPGMxMmFkMDI3Pl0gPyBfX211
dGV4X2xvY2tfY29tbW9uLmNsb25lLjUrMHhlMi8weDEzMQpbIDcyMDAuNzk2MzI1XSAgWzxjMTJh
Y2YzNz5dID8gbXV0ZXhfbG9jaysweDE3LzB4MjUKWyA3MjAwLjc5NjM4MV0gIFs8Zjg1ODU0ZjE+
XSA/IGllZWU4MDIxMV9zY2FuX2NhbmNlbCsweDExLzB4NWMgW21hYzgwMjExXQpbIDcyMDAuNzk2
NDIwXSAgWzxmODU4ZDc1Yj5dID8gaWVlZTgwMjExX2RvX3N0b3ArMHgyYS8weDNmMSBbbWFjODAy
MTFdClsgNzIwMC43OTY0MzVdICBbPGMxMDNhZTBiPl0gPyBfbG9jYWxfYmhfZW5hYmxlX2lwLmNs
b25lLjYrMHgxNS8weDZkClsgNzIwMC43OTY0NDldICBbPGMxMjI0NDJmPl0gPyBkZXZfZGVhY3Rp
dmF0ZV9tYW55KzB4Y2UvMHhmYgpbIDcyMDAuNzk2NDg4XSAgWzxmODU4ZGIzMT5dID8gaWVlZTgw
MjExX3N0b3ArMHhmLzB4MTIgW21hYzgwMjExXQpbIDcyMDAuNzk2NTAyXSAgWzxjMTIwZjlmZj5d
ID8gX19kZXZfY2xvc2VfbWFueSsweDZjLzB4OGEKWyA3MjAwLjc5NjUxNV0gIFs8YzEyMGZhMzk+
XSA/IF9fZGV2X2Nsb3NlKzB4MWMvMHgyYwpbIDcyMDAuNzk2NTI3XSAgWzxjMTIxMjhjZT5dID8g
X19kZXZfY2hhbmdlX2ZsYWdzKzB4OGMvMHgxMDEKWyA3MjAwLjc5NjUzOV0gIFs8YzEyMTI5YTQ+
XSA/IGRldl9jaGFuZ2VfZmxhZ3MrMHgxMC8weDNiClsgNzIwMC43OTY1NTBdICBbPGMxMjFiN2I5
Pl0gPyBkb19zZXRsaW5rKzB4MjZjLzB4NWZmClsgNzIwMC43OTY1NjhdICBbPGMxMDMxNDdiPl0g
PyBzZWxlY3RfdGFza19ycV9mYWlyKzB4NDJmLzB4NjFkClsgNzIwMC43OTY1ODBdICBbPGMxMjFi
ZWY4Pl0gPyBydG5sX3NldGxpbmsrMHhhMS8weGMyClsgNzIwMC43OTY1OTRdICBbPGMxMjFiZTU3
Pl0gPyBydG5sX2dldGxpbmsrMHgxMTUvMHgxMTUKWyA3MjAwLjc5NjYwNl0gIFs8YzEyMWMxOTE+
XSA/IHJ0bmV0bGlua19yY3ZfbXNnKzB4MWEyLzB4MWIxClsgNzIwMC43OTY2MTddICBbPGMxMjFi
ZmVmPl0gPyBfX3J0bmxfdW5sb2NrKzB4YS8weGEKWyA3MjAwLjc5NjYzMF0gIFs8YzEyMmI1MjE+
XSA/IG5ldGxpbmtfcmN2X3NrYisweDJmLzB4NmYKWyA3MjAwLjc5NjY0MV0gIFs8YzEyMWJjNmU+
XSA/IHJ0bmV0bGlua19yY3YrMHgxOC8weDIwClsgNzIwMC43OTY2NTNdICBbPGMxMjJiMTA3Pl0g
PyBuZXRsaW5rX3VuaWNhc3QrMHhjMC8weDExNQpbIDcyMDAuNzk2NjY1XSAgWzxjMTIyYjM4Zj5d
ID8gbmV0bGlua19zZW5kbXNnKzB4MjMzLzB4MjRjClsgNzIwMC43OTY2NzldICBbPGMxMjAyZGJm
Pl0gPyBfX3NvY2tfc2VuZG1zZysweDRlLzB4NTcKWyA3MjAwLjc5NjY5MV0gIFs8YzEyMDM0NmU+
XSA/IHNvY2tfc2VuZG1zZysweDc4LzB4OGYKWyA3MjAwLjc5NjcwNF0gIFs8YzEyMDM0NmU+XSA/
IHNvY2tfc2VuZG1zZysweDc4LzB4OGYKWyA3MjAwLjc5NjcxOF0gIFs8YzEwMjljZmU+XSA/IG5l
ZWRfcmVzY2hlZCsweDExLzB4MWEKWyA3MjAwLjc5NjczMF0gIFs8YzEwMjlkMGM+XSA/IHNob3Vs
ZF9yZXNjaGVkKzB4NS8weDFmClsgNzIwMC43OTY3NDJdICBbPGMxMmFjYTJjPl0gPyBfY29uZF9y
ZXNjaGVkKzB4NS8weDE4ClsgNzIwMC43OTY3NTRdICBbPGMxMmFjYTJjPl0gPyBfY29uZF9yZXNj
aGVkKzB4NS8weDE4ClsgNzIwMC43OTY3NjZdICBbPGMxMjBiMjQ0Pl0gPyB2ZXJpZnlfaW92ZWMr
MHgzZC8weDc1ClsgNzIwMC43OTY3NzhdICBbPGMxMjAzMTE1Pl0gPyBfX3N5c19zZW5kbXNnKzB4
MTI4LzB4MThjClsgNzIwMC43OTY3ODldICBbPGMxMjAzM2Y2Pl0gPyBzb2NrX3NlbmRtc2dfbm9z
ZWMrMHhjOS8weGM5ClsgNzIwMC43OTY4MDFdICBbPGMxMjAzMjVjPl0gPyBzb2NrX3JlY3Ztc2df
bm9zZWMrMHhlMy8weGUzClsgNzIwMC43OTY4MTVdICBbPGMxMGNiMGRlPl0gPyBmZ2V0X2xpZ2h0
KzB4NTYvMHg2OQpbIDcyMDAuNzk2ODMwXSAgWzxjMTExZGY5MT5dID8gc2VjdXJpdHlfc2tfYWxs
b2MrMHhkLzB4ZgpbIDcyMDAuNzk2ODQzXSAgWzxjMTIwNjRhMT5dID8gc2tfcHJvdF9hbGxvYysw
eDdmLzB4ZjcKWyA3MjAwLjc5Njg1NV0gIFs8YzEwMDdhODU+XSA/IF9fc3dpdGNoX3RvKzB4ZDEv
MHhlMgpbIDcyMDAuNzk2ODY2XSAgWzxjMTAyYzQzNz5dID8gbW1kcm9wKzB4Yi8weDE5ClsgNzIw
MC43OTY4NzhdICBbPGMxMDJjNTYzPl0gPyBmaW5pc2hfdGFza19zd2l0Y2grMHg2YS8weDg2Clsg
NzIwMC43OTY4OTBdICBbPGMxMDI5Y2ZlPl0gPyBuZWVkX3Jlc2NoZWQrMHgxMS8weDFhClsgNzIw
MC43OTY5MDJdICBbPGMxMmFjOGFmPl0gPyBzY2hlZHVsZSsweDU5YS8weDVhYQpbIDcyMDAuNzk2
OTEzXSAgWzxjMTBjYWNjZT5dID8gZnB1dCsweDExLzB4MTYxClsgNzIwMC43OTY5MjVdICBbPGMx
MjA0YWJmPl0gPyBzeXNfc2VuZG1zZysweDJjLzB4NDcKWyA3MjAwLjc5NjkzOF0gIFs8YzEyMDRm
N2Y+XSA/IHN5c19zb2NrZXRjYWxsKzB4MTg3LzB4MWRjClsgNzIwMC43OTY5NTNdICBbPGMxMmIy
MjFmPl0gPyBzeXNlbnRlcl9kb19jYWxsKzB4MTIvMHgyOAo=
--000e0cd1e2f64e7a9804ab180f1b--
