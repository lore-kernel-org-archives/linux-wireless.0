Return-Path: <linux-wireless-owner@vger.kernel.org>
Received: from mxm.seznam.cz ([77.75.72.45]:11409 "EHLO mxm.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbYLBCH7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 21:07:59 -0500
To: linville@tuxdriver.com
In-Reply-To: <819.1442-26431-1638312140-1227886675@seznam.cz>
Date: Tue, 02 Dec 2008 03:07:45 +0100 (CET)
Cc: linux-wireless@vger.kernel.org
From: =?iso-8859-2?Q?Carlos=20Lau=E9?= <CarlosL@seznam.cz>
Subject: =?us-ascii?Q?=5BPATCH=20v2=5D=20wireless=2Dregdb=3A=20Update=20regulatory=20rules=20for=20Czech=20Republic=20=28CZ=29?=
Mime-Version: 1.0
Message-Id: <819.1449-20802-468374075-1228183665@seznam.cz>
Content-Type: text/plain;
	charset="iso-8859-2"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is a proper git diff of the proposed changes to meet regulatory needs for Czech Republic.

- minor changes to 2.4GHz
- actual information about 5GHz 

unfortunately we shouldn't use full power on some frequencies, this is possible only if we can ensure the use of auto TX power regulation (VOR-12-08-2005-34 Article 2 g) ), staying 3dB below maximum allowed power for now (at 5250 - 5350 MHz and 5470 - 5725 MHz).

 I've found the documents (the ones in the patch) as a unofficial translation to English, hosted on the official website of the Czech Telecommunication Offiice. The informations there appears to be correct, identical to the Czech official documents. The official documents can be found at: 
http://www.ctu.eu/1/download/Opatreni%20obecne%20povahy/VO_R_12_08_2005_34.pdf
http://www.ctu.eu/1/download/OOP/Rok_2007/VO_R_12_05_2007_6.pdf
http://www.ctu.eu/1/download/OOP/Rok_2007/VO_R_10_03_2007_4.pdf


Signed-off-by: Carlos Laué <carlosl@seznam.cz>

diff --git a/db.txt b/db.txt
index 6a282b6..6cd65a2 100644
--- a/db.txt
+++ b/db.txt
@@ -141,10 +141,15 @@ country CY:
        (5250 - 5330 @ 40), (N/A, 20), DFS
        (5490 - 5710 @ 40), (N/A, 27), DFS

+# Data from http://www.ctu.eu/164/download/VOR/VOR-12-08-2005-34.pdf
+# http://www.ctu.eu/164/download/VOR/VOR-12-05-2007-6-AN.pdf
+# and http://www.ctu.eu/164/download/VOR/VOR-10-10-2008-14-AN.pdf
 country CZ:
-       (2402 - 2482 @ 40), (N/A, 20)
-       (5170 - 5250 @ 40), (N/A, 20)
-       (5250 - 5330 @ 40), (N/A, 20), DFS
+       (2400 - 2483.5 @ 40), (N/A, 100 mW)
+       (5150 - 5250 @ 40), (N/A, 200 mW), NO-OUTDOOR
+       (5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
+       (5470 - 5725 @ 40), (N/A, 500 mW), DFS
+       (5725 - 5875 @ 40), (N/A, 25 mW)

 # Data from "Frequenznutzungsplan" (as published in April 2008),
 # downloaded from http://www.bundesnetzagentur.de/media/archive/13358.pdf
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
>From linux-wireless-owner@vger.kernel.org Tue Dec  2 10:42:49 2008
Return-Path: <linux-wireless-owner@vger.kernel.org>
Received: from jmalinen.user.openhosting.com [128.177.27.249]
	by jm.kir.nu with POP3 (fetchmail-6.3.8)
	for <jm@localhost> (single-drop); Tue, 02 Dec 2008 10:42:49 +0200 (EET)
Received: from vger.kernel.org (vger.kernel.org [209.132.176.167])
	by jmalinen.user.openhosting.com (8.13.8/8.13.8) with ESMTP id mB23IHiZ005270
	for <j@w1.fi>; Mon, 1 Dec 2008 22:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbYLBDSO (ORCPT <rfc822;j@w1.fi>);
	Mon, 1 Dec 2008 22:18:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYLBDSO
	(ORCPT <rfc822;linux-wireless-outgoing>);
	Mon, 1 Dec 2008 22:18:14 -0500
Received: from n13b.bullet.mail.mud.yahoo.com ([68.142.207.222]:29247 "HELO
	n13b.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753225AbYLBDSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 22:18:12 -0500
X-Greylist: delayed 377 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Dec 2008 22:18:12 EST
Received: from [209.191.108.96] by n13.bullet.mail.mud.yahoo.com with NNFMP; 02 Dec 2008 03:11:55 -0000
Received: from [76.13.13.26] by t3.bullet.mud.yahoo.com with NNFMP; 02 Dec 2008 03:11:55 -0000
Received: from [76.13.10.183] by t3.bullet.mail.ac4.yahoo.com with NNFMP; 02 Dec 2008 03:11:55 -0000
Received: from [127.0.0.1] by omp124.mail.ac4.yahoo.com with NNFMP; 02 Dec 2008 03:11:55 -0000
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 198339.49210.bm@omp124.mail.ac4.yahoo.com
Received: (qmail 53228 invoked by uid 60001); 2 Dec 2008 03:11:55 -0000
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=2ofmIXopEEozsRi2skrf5VvVtd+ZB0sUnUkspViqVDQ+7yCevnP0/UPt0NcTMKv9kHSf77E8RAr0mVbWYAWBlcTELks5oNARCBqLaEDWfKIUIX9G1uIVUZ5ISXfkGa7AUZc30JMni4zpOiOFStnbdSJJlRv294X/Lc+aGqXYFXI=;
X-YMail-OSG: REcOiyAVM1l8.8hlyhyDUX7_cwvbQSLZ4yeOwIhhx_DBEN5o6hVl2zaSyumvZNYTsUEBg3KjeZ9Gdd_YoJCbYid7N7Tq0RfTj3O4ONcYHpoiWAe05zTddW2uTYD2rxEgdCTdZKixa5u5REqoy412cljyq0kY
Received: from [125.167.124.102] by web59615.mail.ac4.yahoo.com via HTTP; Mon, 01 Dec 2008 19:11:55 PST
X-Mailer: YahooMailWebService/0.7.260.1
Date: 	Mon, 1 Dec 2008 19:11:55 -0800 (PST)
From: Irwan Siajadi <dev.bahamot@yahoo.com>
Subject: Re: ath5k: can't browse at all.
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Pavel Roskin <proski@gnu.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <63885.52788.qm@web59615.mail.ac4.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: 	linux-wireless@vger.kernel.org
Status: RO
Content-Length: 3585




--- On Mon, 12/1/08, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:

> From: Luis R. Rodriguez <lrodriguez@atheros.com>
> Subject: Re: ath5k: can't browse at all.
> To: "Irwan Siajadi" <dev.bahamot@yahoo.com>
> Cc: "Pavel Roskin" <proski@gnu.org>, "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
> Date: Monday, December 1, 2008, 5:11 PM
> On Sun, Nov 30, 2008 at 08:53:36AM -0800, Irwan Siajadi
> wrote:
> > --- On Tue, 11/25/08, Pavel Roskin
> <proski@gnu.org> wrote:
> > 
> > > From: Pavel Roskin <proski@gnu.org>
> > > Subject: Re: ath5k: can't browse at all.
> > > To: "Irwan Siajadi"
> <dev.bahamot@yahoo.com>
> > > Cc: linux-wireless@vger.kernel.org
> > > Date: Tuesday, November 25, 2008, 8:02 PM
> > > On Tue, 2008-11-25 at 09:24 -0800, Irwan Siajadi
> wrote:
> > >
> > > > Further testing shows that if I change from
> WPA2/AES
> > > to WPA/TIKIP, I
> > > > can finally browse. But it's still hit
> and missed,
> > > I need to reload
> > > > the pages once or twice before the pages can
> load
> > > properly.
> > >
> > > Try disabling hardware crypto in the driver:
> > >
> > > rmmod ath5k
> > > modprobe ath5k nohwcrypt=1
> > 
> > Sorry for the late reply, being busy with other
> stuffs.
> > Anyway, disabling hardware cyrpto didn't make any
> changes.
> > 
> > >
> > > In any case, check messages from wpa_supplicant. 
> Maybe
> > > it's
> > > reauthenticating very often.  If you flood ping
> the router
> > > ("ping -f"),
> > > you would probably see growing dots that
> represent lost
> > > packets.
> > 
> > Flood ping the router doesn't have any lost
> packets (although only for a
> > minute or so). And my router's log shows that the
> laptop didn't
> > re-authenticate very often.
> > 
> > I've also compiled vanilla 2.6.26 and 2.6.27 with
> ath5k (compat-wireless).
> > 
> > - 2.6.26.8 + ath5k (compat-wireless-old-2008-11-29,
> files last editted on
> > 2008-09-16):
> > -> ping shows some packets loss.
> > -> can browse any websites.
> 
> Lets focus on >= 2.6.27.
> 
> > 
> > - 2.6.27.7 + ath5k (compat-wireless-2008-11-26):
> > -> ping doesn't have any packet loss.
> > -> can't browse, browser always waiting for the
> response from the server.
> > Monitoring the traffics shows that there are tx
> packets, but there's no rx
> > packets.
> > 
> > Anything else I can try?
> 
> You say you can ping fine but... browsing doesn't
> work?? Maybe a
> firewall issue?
> 
> /etc/init.d/iptables stop
> 
> I agree with Pavel this does not seem like a driver issue.
> Do you have
> your AP configured to disable :80 TCP communication? Can
> you try a simple
> netcat server and netcat client on different ports and also
> on port 80
> just to see if its really firewall/AP configuration.


Firewall on both end (router-ap and laptop) is disabled.
I can't do netcat on the server since it's not a PC box. It's an all in 
one unit (ADSL modem+AP+router). But I did wireshark on the laptop before 
reading your email. And I can see many TCP retransmission while trying to 
browse. If you like I can attach the log and send it to you. 


As comparison, I also do wireshark while using ndiswrapper. I can find TCP 
retransmission while using ndiswrapper, but doesn't really affect browsing 
or large file transfer through SMB.


PS: If you prefer netcat, please tell me, I'll do that and send the log if 
you like.


> 
>   Luis

Irwan.



      

