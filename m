Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpout1.wanadoo.co.uk ([80.12.242.29]:41687 "EHLO
	smtpout.wanadoo.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3CTPWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 11:22:08 -0400
Date: Wed, 20 Mar 2013 16:22:05 +0100 (CET)
From: nick@nhthomas.freeserve.co.uk
Reply-To: nick@nhthomas.freeserve.co.uk
To: linux-wireless@vger.kernel.org
Message-ID: <1456708.37551363792925678.JavaMail.www@wwinf3723> (sfid-20130320_162218_449486_3575E21A)
Subject: ath6kl_usb - ping problems when compiled for sh4.
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_2355_31897460.1363792925652"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_2355_31897460.1363792925652
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi
I tried a wek or so ago to get some help with my ping problems.

Essentially, the problem I see is that my AR6004 based USB wifi adaptor can associate with an AP OK, and gets an IP address via DHCP just fine.
But, pings don't work.

I can't ping to the device from another PC on the same subnet, and I can't ping out.

And, I think my problem has something to do with MAC addresses.

According to wireshark, pings are received by the USB wifi device OK, but the echo reply is going back out to the wrong MAC address - so it's never received by the ping originator.

Attached is some debug from the driver - which hopefully someone will understand.

Someone suggested that my problem might be endianness related - but I can see that myself - because Association with the AP, and DHCP wouldn't work if that was the case.
The problem looks to me more like a problem with structure alignment - where the MAC address table is shifted over.


You will see in the attached file that the ping originator MAC address is 20:CF:30:94:83:7B
And, the MAC address of the wifi adaptor itself is 00:03:7F:20:50:59

According to wireshark the MAC address which the echo reply is going back to is neither of these.

Any ideas what's wrong?


Regards

Nick
------=_Part_2355_31897460.1363792925652
Content-Type: text/plain; name=ath6kl_debug.txt
content-transfer-encoding: quoted-printable
Content-Disposition: attachment; size=17642; filename=ath6kl_debug.txt

Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl_usb_recv_complete: recv pipe: 6=
, stat:0, len:150 urb:0x89ae0c20
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl usb recv callback buf:0x892721e=
0
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl_rx: ar=3D0x86c4d2a0 eid=3D2, sk=
b=3D0x892721e0, data=3D0x88a6b026, len=3D0x90 status:0
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl_rx
Jan  1 00:12:41 H251 kernel: rx 00000000: 2a 00 e1 0f 00 46 00 00 00 00 00 =
00 00 00 00 00  *....F..........
Jan  1 00:12:41 H251 kernel: rx 00000010: 00 00 02 00 7e 00 00 0f 27 00 df =
0b 00 46 00 00  ....~...'....F..
Jan  1 00:12:41 H251 kernel: rx 00000020: 00 00 00 00 00 00 00 00 00 00 02 =
00 82 00 00 10  ................
Jan  1 00:12:41 H251 kernel: rx 00000030: 25 00 e0 0b 00 46 00 00 00 00 08 =
42 00 00 ff ff  %%....F.....B....
Jan  1 00:12:41 H251 kernel: rx 00000040: ff ff 08 02 00 00 ff ff ff ff ff =
ff ff ff ff ff  ................
Jan  1 00:12:41 H251 kernel: rx 00000050: ff ff 20 cf 30 94 83 7b 00 36 aa =
aa 03 00 00 00  .. .0..{.6......
Jan  1 00:12:41 H251 kernel: rx 00000060: 08 06 00 01 08 00 06 04 00 01 20 =
cf 30 94 83 7b  .......... .0..{
Jan  1 00:12:41 H251 kernel: rx 00000070: c0 a8 00 65 00 00 00 00 00 00 c0 =
a8 00 07 00 00  ...e............
Jan  1 00:12:41 H251 kernel: rx 00000080: 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00  ................
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl_data_tx: skb=3D0x87e74c00, data=
=3D0x89047832, len=3D0x2a
Jan  1 00:12:41 H251 kernel: ath6kl: TSRS IE enabled::MinPhy 0->NominalPhy =
=3D=3D=3D> 0
Jan  1 00:12:41 H251 kernel: ath6kl: sending create_pstream_cmd: ac=3D0  ts=
id:255
Jan  1 00:12:41 H251 kernel: ath6kl: wmi tx id 5 len 64 flag 0
Jan  1 00:12:41 H251 kernel: wmi tx 00000000: 00 00 00 00 00 00 00 00 88 13=
 00 00 00 00 00 00  ................
Jan  1 00:12:41 H251 kernel: wmi tx 00000010: 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00  ................
Jan  1 00:12:41 H251 kernel: wmi tx 00000020: 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00  ................
Jan  1 00:12:41 H251 kernel: wmi tx 00000030: 00 00 00 00 00 00 00 00 00 00=
 00 00 00 ff 00 00  ................
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl_control_tx: skb=3D0x87e74840, l=
en=3D0x46 eid =3D1
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl_htc_pipe_tx: endPointId: 1, buf=
fer: 0x888DECC2, length: 70
Jan  1 00:12:41 H251 kernel: ath6kl: htc_try_send: (queue:0x89823A2C depth:=
1)
Jan  1 00:12:41 H251 kernel: ath6kl: get_htc_packet_credit_based: got head =
packet:0x87E493A4 , queue depth: 1
Jan  1 00:12:41 H251 kernel: ath6kl: get_htc_packet_credit_based: creds req=
uired:1got:1
Jan  1 00:12:41 H251 kernel: ath6kl: get_htc_packet_credit_based: host need=
s credits
Jan  1 00:12:41 H251 kernel: ath6kl: htc_issue_packets: queue: 0x898239CC, =
pkts 1
Jan  1 00:12:41 H251 kernel: ath6kl: hif pipe send
Jan  1 00:12:41 H251 kernel: ath6kl: +ath6kl_usb_send pipe : 0, buf:0x87e74=
840
Jan  1 00:12:41 H251 kernel: ath6kl: athusb bulk send submit:0, 0xC0008200 =
(ep:0x01), 76 bytes
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl_data_tx
Jan  1 00:12:41 H251 kernel: tx 00000000: 00 00 00 00 00 00 7f 20 50 59 00 =
24 00 03 7f 20  ....... PY.$...=20
Jan  1 00:12:41 H251 kernel: tx 00000010: 50 59 00 24 aa aa 03 00 00 00 08 =
06 00 01 08 00  PY.$............
Jan  1 00:12:41 H251 kernel: tx 00000020: 06 04 00 02 00 03 7f 20 50 59 c0 =
a8 00 07 20 cf  ....... PY.... .
Jan  1 00:12:41 H251 kernel: tx 00000030: 30 94 83 7b c0 a8 00 65          =
                0..{...e
Jan  1 00:12:41 H251 kernel: ath6kl: p2p_flowctrl get con_id 0 00:03:7f:20:=
50:59
Jan  1 00:12:41 H251 kernel: ath6kl: p2p_flowctrl schedule pkt 86c4d2a0 sen=
d
Jan  1 00:12:41 H251 kernel: ath6kl:=20
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl_usb_usb_transmit_complete: pipe=
: 0, stat:0, len:76
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl_usb_recv_complete: recv pipe: 6=
, stat:0, len:10 urb:0x88930540
Jan  1 00:12:41 H251 kernel: ath6kl_htc_pipe_tx: endPointId: 2, buffer: 0x8=
9047824, length: 56
Jan  1 00:12:41 H251 kernel: ath6kl: htc_try_send: (queue:0x89823B10 depth:=
1)
Jan  1 00:12:41 H251 kernel: ath6kl: get_htc_packet_credit_based: got head =
packet:0x87FF65CC , queue depth: 1
Jan  1 00:12:41 H251 kernel: ath6kl: get_htc_packet_credit_based: creds req=
uired:1got:7
Jan  1 00:12:41 H251 kernel: ath6kl: htc_issue_packets: queue: 0x89823AB0, =
pkts 1
Jan  1 00:12:41 H251 kernel: ath6kl: hif pipe send
Jan  1 00:12:41 H251 kernel: ath6kl: +ath6kl_usb_send pipe : 1, buf:0x87e74=
c00
Jan  1 00:12:41 H251 kernel: ath6kl: athusb bulk send submit:1, 0xC0010200 =
(ep:0x02), 62 bytes
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl_usb_usb_transmit_complete: pipe=
: 1, stat:0, len:62
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl_usb_recv_complete: recv pipe: 6=
, stat:0, len:52 urb:0x889301c0
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl usb: bulk recv submit:6, 0xC041=
0280(ep:0x82), 2048 bytes buf:0x892721e0
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl usb: bulk recv submit:6, 0xC041=
0280(ep:0x82), 2048 bytes buf:0x87e742a0
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl usb: bulk recv submit:6, 0xC041=
0280(ep:0x82), 2048 bytes buf:0x87e747a0
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl usb: bulk recv submit:6, 0xC041=
0280(ep:0x82), 2048 bytes buf:0x87e745c0
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl usb: bulk recv submit:6, 0xC041=
0280(ep:0x82), 2048 bytes buf:0x87e740c0
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl usb: bulk recv submit:6, 0xC041=
0280(ep:0x82), 2048 bytes buf:0x89be2900
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl usb: bulk recv submit:6, 0xC041=
0280(ep:0x82), 2048 bytes buf:0x89be2720
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl usb: bulk recv submit:6, 0xC041=
0280(ep:0x82), 2048 bytes buf:0x89be2d60
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl usb: bulk recv submit:6, 0xC041=
0280(ep:0x82), 2048 bytes buf:0x89be22c0
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl usb: bulk recv submit:6, 0xC041=
0280(ep:0x82), 2048 bytes buf:0x89be29a0
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl usb: bulk recv submit:6, 0xC041=
0280(ep:0x82), 2048 bytes buf:0x89be2ae0
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl usb: bulk recv submit:6, 0xC041=
0280(ep:0x82), 2048 bytes buf:0x89bbb6c0
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl usb: bulk recv submit:6, 0xC041=
0280(ep:0x82), 2048 bytes buf:0x88a3a820
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl usb: bulk recv submit:6, 0xC041=
0280(ep:0x82), 2048 bytes buf:0x88a3a960
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl usb: bulk recv submit:6, 0xC041=
0280(ep:0x82), 2048 bytes buf:0x88a3a8c0
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl usb: bulk recv submit:6, 0xC041=
0280(ep:0x82), 2048 bytes buf:0x89272780
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl_usb_recv_complete: recv pipe: 6=
, stat:0, len:52 urb:0x87db10a0
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl usb recv callback buf:0x8927228=
0
Jan  1 00:12:41 H251 kernel: ath6kl:   Report indicated 1 credits to distri=
bute
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl usb recv callback buf:0x892726e=
0
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl_rx: ar=3D0x86c4d2a0 eid=3D1, sk=
b=3D0x892726e0, data=3D0x87ffd026, len=3D0x2e status:0
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl_rx
Jan  1 00:12:41 H251 kernel: rx 00000000: 14 90 00 00 00 00 0d 1f 00 00 00 =
00 00 00 00 00  ................
Jan  1 00:12:41 H251 kernel: rx 00000010: 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00  ................
Jan  1 00:12:41 H251 kernel: rx 00000020: 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00        ..............
Jan  1 00:12:41 H251 kernel: ath6kl: wmi rx id 36884 len 40
Jan  1 00:12:41 H251 kernel: wmi rx 00000000: 0d 1f 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00  ................
Jan  1 00:12:41 H251 kernel: wmi rx 00000010: 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00  ................
Jan  1 00:12:41 H251 kernel: wmi rx 00000020: 00 00 00 00 00 00 00 00      =
                    ........
Jan  1 00:12:41 H251 kernel: ath6kl: WMI_FLOWCTRL_IND_EVENTID
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl usb recv callback buf:0x89be24a=
0
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl_rx: ar=3D0x86c4d2a0 eid=3D1, sk=
b=3D0x89be24a0, data=3D0x88a1c026, len=3D0x2e status:0
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl_rx
Jan  1 00:12:41 H251 kernel: rx 00000000: 14 90 00 00 00 00 0d 00 00 00 00 =
00 00 00 00 00  ................
Jan  1 00:12:41 H251 kernel: rx 00000010: 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00  ................
Jan  1 00:12:41 H251 kernel: rx 00000020: 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00        ..............
Jan  1 00:12:41 H251 kernel: ath6kl: wmi rx id 36884 len 40
Jan  1 00:12:41 H251 kernel: wmi rx 00000000: 0d 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00  ................
Jan  1 00:12:41 H251 kernel: wmi rx 00000010: 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00  ................
Jan  1 00:12:41 H251 kernel: wmi rx 00000020: 00 00 00 00 00 00 00 00      =
                    ........
Jan  1 00:12:41 H251 kernel: ath6kl: WMI_FLOWCTRL_IND_EVENTID
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl usb xmit callback buf:0x87e7484=
0
Jan  1 00:12:41 H251 kernel: ath6kl: do_send_completion: calling ep 1, send=
 complete multiple callback(1 pkts)
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl_tx_complete: skb=3D0x87e74840 d=
ata=3D0x888decc2 len=3D0x46 eid=3D1 OK
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl usb xmit callback buf:0x87e74c0=
0
Jan  1 00:12:41 H251 kernel: ath6kl: do_send_completion: calling ep 2, send=
 complete multiple callback(1 pkts)
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl_tx_complete: skb=3D0x87e74c00 d=
ata=3D0x89047824 len=3D0x38 eid=3D2 OK
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl_usb_recv_complete: recv pipe: 6=
, stat:0, len:52 urb:0x87db1120
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl usb recv callback buf:0x89be268=
0
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl_rx: ar=3D0x86c4d2a0 eid=3D1, sk=
b=3D0x89be2680, data=3D0x8896f026, len=3D0x2e status:0
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl_rx
Jan  1 00:12:41 H251 kernel: rx 00000000: 14 90 00 00 00 00 0d 1f 00 00 00 =
00 00 00 00 00  ................
Jan  1 00:12:41 H251 kernel: rx 00000010: 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00  ................
Jan  1 00:12:41 H251 kernel: rx 00000020: 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00        ..............
Jan  1 00:12:41 H251 kernel: ath6kl: wmi rx id 36884 len 40
Jan  1 00:12:41 H251 kernel: wmi rx 00000000: 0d 1f 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00  ................
Jan  1 00:12:41 H251 kernel: wmi rx 00000010: 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00  ................
Jan  1 00:12:41 H251 kernel: wmi rx 00000020: 00 00 00 00 00 00 00 00      =
                    ........
Jan  1 00:12:41 H251 kernel: ath6kl: WMI_FLOWCTRL_IND_EVENTID
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl_usb_recv_complete: recv pipe: 6=
, stat:0, len:52 urb:0x87db11a0
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl usb recv callback buf:0x89be286=
0
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl_rx: ar=3D0x86c4d2a0 eid=3D1, sk=
b=3D0x89be2860, data=3D0x89035026, len=3D0x2e status:0
Jan  1 00:12:41 H251 kernel: ath6kl: ath6kl_rx
Jan  1 00:12:41 H251 kernel: rx 00000000: 14 90 00 00 00 00 0d 00 00 00 00 =
00 00 00 00 00  ................
Jan  1 00:12:41 H251 kernel: rx 00000010: 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00  ................
Jan  1 00:12:41 H251 kernel: rx 00000020: 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00        ..............
Jan  1 00:12:41 H251 kernel: ath6kl: wmi rx id 36884 len 40
Jan  1 00:12:41 H251 kernel: wmi rx 00000000: 0d 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00  ................
Jan  1 00:12:41 H251 kernel: wmi rx 00000010: 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00  ................
Jan  1 00:12:41 H251 kernel: wmi rx 00000020: 00 00 00 00 00 00 00 00      =
                    ........
Jan  1 00:12:41 H251 kernel: ath6kl: WMI_FLOWCTRL_IND_EVENTID
Jan  1 00:12:46 H251 kernel: ath6kl: ath6kl_usb_recv_complete: recv pipe: 6=
, stat:0, len:16 urb:0x87db1220
Jan  1 00:12:46 H251 kernel: ath6kl: ath6kl usb recv callback buf:0x89be218=
0
Jan  1 00:12:46 H251 kernel: ath6kl: ath6kl_rx: ar=3D0x86c4d2a0 eid=3D1, sk=
b=3D0x89be2180, data=3D0x89bd6026, len=3D0xa status:0
Jan  1 00:12:46 H251 kernel: ath6kl: ath6kl_rx
Jan  1 00:12:46 H251 kernel: rx 00000000: 07 10 00 00 00 00 00 00 00 00    =
                ..........
Jan  1 00:12:46 H251 kernel: ath6kl: wmi rx id 4103 len 4
Jan  1 00:12:46 H251 kernel: wmi rx 00000000: 00 00 00 00                  =
                    ....
Jan  1 00:12:46 H251 kernel: ath6kl: WMI_PSTREAM_TIMEOUT_EVENTID
Jan  1 00:12:48 H251 kernel: ath6kl: ath6kl_usb_recv_complete: recv pipe: 6=
, stat:0, len:277 urb:0x87db12a0
Jan  1 00:12:48 H251 kernel: ath6kl: ath6kl usb recv callback buf:0x89be254=
0
Jan  1 00:12:48 H251 kernel: ath6kl: ath6kl_rx: ar=3D0x86c4d2a0 eid=3D2, sk=
b=3D0x89be2540, data=3D0x88a7e026, len=3D0x10f status:0
Jan  1 00:12:48 H251 kernel: ath6kl: ath6kl_rx
Jan  1 00:12:48 H251 kernel: rx 00000000: 24 00 2c 00 00 46 00 00 00 00 00 =
00 00 00 00 00  $.,..F..........
Jan  1 00:12:48 H251 kernel: rx 00000010: 00 00 02 00 82 00 00 10 25 00 e0 =
0b 00 46 00 00  ........%%....F..
Jan  1 00:12:48 H251 kernel: rx 00000020: 00 00 00 00 00 00 00 00 00 00 02 =
00 7e 00 00 11  ............~...
Jan  1 00:12:48 H251 kernel: rx 00000030: 26 00 e1 0b 00 46 00 00 00 00 08 =
62 00 00 ff ff  &....F.....b....
Jan  1 00:12:48 H251 kernel: rx 00000040: ff ff 08 22 00 00 ff ff ff ff ff =
ff ff ff ff ff  ..."............
Jan  1 00:12:48 H251 kernel: rx 00000050: ff ff 20 cf 30 94 83 7b 00 b5 aa =
aa 03 00 00 00  .. .0..{........
Jan  1 00:12:48 H251 kernel: rx 00000060: 08 00 45 00 00 ad b2 42 00 00 80 =
11 c6 f0 c0 a8  ..E....B........
Jan  1 00:12:48 H251 kernel: rx 00000070: 00 65 ff ff ff ff 44 5c 44 5c 00 =
99 cd 56 7b 22  .e....D\D\...V{"
Jan  1 00:12:48 H251 kernel: rx 00000080: 68 6f 73 74 5f 69 6e 74 22 3a 20 =
33 30 31 31 37  host_int": 30117
Jan  1 00:12:48 H251 kernel: rx 00000090: 32 33 33 35 2c 20 22 76 65 72 73 =
69 6f 6e 22 3a  2335, "version":
Jan  1 00:12:48 H251 kernel: rx 000000a0: 20 5b 31 2c 20 38 5d 2c 20 22 64 =
69 73 70 6c 61   [1, 8], "displa
Jan  1 00:12:48 H251 kernel: rx 000000b0: 79 6e 61 6d 65 22 3a 20 22 33 30 =
31 31 37 32 33  yname": "3011723
Jan  1 00:12:48 H251 kernel: rx 000000c0: 33 35 22 2c 20 22 70 6f 72 74 22 =
3a 20 31 37 35  35", "port": 175
Jan  1 00:12:48 H251 kernel: rx 000000d0: 30 30 2c 20 22 6e 61 6d 65 73 70 =
61 63 65 73 22  00, "namespaces"
Jan  1 00:12:48 H251 kernel: rx 000000e0: 3a 20 5b 31 35 37 34 33 37 30 37 =
32 2c 20 31 36  : [157437072, 16
Jan  1 00:12:48 H251 kernel: rx 000000f0: 36 34 32 34 30 39 36 2c 20 31 35 =
37 34 31 36 39  6424096, 1574169
Jan  1 00:12:48 H251 kernel: rx 00000100: 37 30 2c 20 31 39 33 34 36 35 34 =
36 36 5d 7d     70, 193465466]}
Jan  1 00:12:48 H251 kernel: ath6kl: ath6kl_usb_recv_complete: recv pipe: 6=
, stat:0, len:277 urb:0x87db1320
Jan  1 00:12:48 H251 kernel: ath6kl: ath6kl usb recv callback buf:0x89be2e0=
0
Jan  1 00:12:48 H251 kernel: ath6kl: ath6kl_rx: ar=3D0x86c4d2a0 eid=3D2, sk=
b=3D0x89be2e00, data=3D0x88a7c026, len=3D0x10f status:0
Jan  1 00:12:48 H251 kernel: ath6kl: ath6kl_rx
Jan  1 00:12:48 H251 kernel: rx 00000000: 24 00 2d 00 00 46 00 00 00 00 00 =
00 00 00 00 00  $.-..F..........
Jan  1 00:12:48 H251 kernel: rx 00000010: 00 00 02 00 7e 00 00 11 26 00 e1 =
0b 00 46 00 00  ....~...&....F..
Jan  1 00:12:48 H251 kernel: rx 00000020: 00 00 00 00 00 00 00 00 00 00 02 =
00 82 00 00 12  ................
Jan  1 00:12:48 H251 kernel: rx 00000030: 25 00 e2 0b 00 46 00 00 00 00 08 =
42 00 00 ff ff  %%....F.....B....
Jan  1 00:12:48 H251 kernel: rx 00000040: ff ff 08 02 00 00 ff ff ff ff ff =
ff ff ff ff ff  ................
Jan  1 00:12:48 H251 kernel: rx 00000050: ff ff 20 cf 30 94 83 7b 00 b5 aa =
aa 03 00 00 00  .. .0..{........
Jan  1 00:12:48 H251 kernel: rx 00000060: 08 00 45 00 00 ad b2 43 00 00 80 =
11 05 48 c0 a8  ..E....C.....H..
Jan  1 00:12:48 H251 kernel: rx 00000070: 00 65 c0 a8 00 ff 44 5c 44 5c 00 =
99 0b af 7b 22  .e....D\D\....{"
Jan  1 00:12:48 H251 kernel: rx 00000080: 68 6f 73 74 5f 69 6e 74 22 3a 20 =
33 30 31 31 37  host_int": 30117
Jan  1 00:12:48 H251 kernel: rx 00000090: 32 33 33 35 2c 20 22 76 65 72 73 =
69 6f 6e 22 3a  2335, "version":
Jan  1 00:12:48 H251 kernel: rx 000000a0: 20 5b 31 2c 20 38 5d 2c 20 22 64 =
69 73 70 6c 61   [1, 8], "displa
Jan  1 00:12:48 H251 kernel: rx 000000b0: 79 6e 61 6d 65 22 3a 20 22 33 30 =
31 31 37 32 33  yname": "3011723
Jan  1 00:12:48 H251 kernel: rx 000000c0: 33 35 22 2c 20 22 70 6f 72 74 22 =
3a 20 31 37 35  35", "port": 175
Jan  1 00:12:48 H251 kernel: rx 000000d0: 30 30 2c 20 22 6e 61 6d 65 73 70 =
61 63 65 73 22  00, "namespaces"
Jan  1 00:12:48 H251 kernel: rx 000000e0: 3a 20 5b 31 35 37 34 33 37 30 37 =
32 2c 20 31 36  : [157437072, 16
Jan  1 00:12:48 H251 kernel: rx 000000f0: 36 34 32 34 30 39 36 2c 20 31 35 =
37 34 31 36 39  6424096, 1574169
Jan  1 00:12:48 H251 kernel: rx 00000100: 37 30 2c 20 31 39 33 34 36 35 34 =
36 36 5d 7d     70, 193465466]}


------=_Part_2355_31897460.1363792925652--

