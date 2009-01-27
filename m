Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:45214 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752474AbZA0UAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 15:00:37 -0500
Message-ID: <497F67D9.5040709@lwfinger.net> (sfid-20090127_210041_822585_BA30E7FA)
Date: Tue, 27 Jan 2009 14:00:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	barreyromartin@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [RFT V2] rtl8187: Fix OFDM power settings for RTL8187L
References: <49790961.JdcKIZyYlMNFSiuO%Larry.Finger@lwfinger.net> <4979DD39.9000601@hauke-m.de> <20090123153144.GA13658@tuxdriver.com> <497B05AF.5050701@hauke-m.de> <497D2BB3.9000002@lwfinger.net> <497F5F70.50304@hauke-m.de>
In-Reply-To: <497F5F70.50304@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hauke Mehrtens wrote:
> With this patch included and pid the rate goes up to 24Mb/s, but the
> connection is stable. Without this patch is is only up to 11Mb/s. The
> connection is still unusable with minstrel, it goes up too fare. It
> starts with 24Mb/s and the connection drops. After some time it goes up
> to 54Mb/s, but then it goes down again and the connection is working
> again for a minute till the procedure begins again.
> 
> What do you mean with rc_stats ?

The statistics for the mistrel algorithn are presented in the /sys
tree in a file named rc_stats. The easy way to see that data is to do
the following:

STATS=$(find /sys -name rc_stats)
sudo cat $STATS

You will get output that looks like

rate     throughput  ewma prob   this prob  this succ/attempt
success    attempts
     1         0.9       99.9      100.0          0(  0)        855
      873
     2         1.8       95.7      100.0          0(  0)         11
       11
  P  5.5       5.0       99.9      100.0          0(  0)         77
       77
    11         9.1       95.9      100.0          0(  0)         14
       16
     6         5.4       95.6      100.0          0(  0)         16
       19
     9         8.0       95.7      100.0          0(  0)         11
       11
    12        10.6       95.7      100.0          0(  0)         11
       11
    18        15.5       95.7      100.0          0(  0)         11
       11
    24        20.4       96.0      100.0          0(  0)        276
      279
    36         5.9       96.0      100.0          0(  0)         76
       78
 t  48         6.5       76.5      100.0          0(  0)       2958
     3034
T   54        20.0       99.9      100.0          1(  1)       6220
     6400

Total packet count::    ideal 9216      lookaround 485

These data are for my RTL8187, which is running at 54 Mb/s (the line
with the T) and the success rate at this speed is 6220/6400 (97%).

Let the mistrel method go through several of those cycles that you
mention and then dump and post this table. Perhaps the experts will
see what is wrong.

Larry


Larry



