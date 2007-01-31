Return-path: <wireless-bounces@tuxdriver.com>
Received: from fencepost.gnu.org (fencepost.gnu.org [199.232.76.164])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0V3O0Fa004423
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 22:24:26 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>) id 1HC63p-0002Y3-8N
	for wireless@lists.tuxdriver.org; Tue, 30 Jan 2007 22:23:01 -0500
Subject: Re: SIOCGIWRANGE and dscape
From: Pavel Roskin <proski@gnu.org>
To: Jon Smirl <jonsmirl@gmail.com>
In-Reply-To: <9e4733910701301911p6c687565h65bce1aedf7e13a3@mail.gmail.com>
References: <9e4733910701301636i18a21f31q421cc7d5c61f6c99@mail.gmail.com>
	<200701302012.23302.flamingice@sourmilk.net>
	<20070131025234.GB7061@jm.kir.nu>
	<9e4733910701301911p6c687565h65bce1aedf7e13a3@mail.gmail.com>
Date: Tue, 30 Jan 2007 22:23:58 -0500
Message-Id: <1170213838.11455.63.camel@dv>
Mime-Version: 1.0
Cc: wireless@lists.tuxdriver.org
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Sender: wireless-bounces@tuxdriver.com
Errors-To: wireless-bounces@tuxdriver.com

On Tue, 2007-01-30 at 22:11 -0500, Jon Smirl wrote:

> Managed mode doesn't need to know the regulatory domain, right? It
> picks it up from the AP.

I'm afraid it does.  The station can initiate scan requests.  This
should be done on authorized frequencies only.  Some countries disallow
passive scanning outright, and that's something the card should know as
well.  The power limits are also different.

Still, I think we could have a minimal managed mode, in which the
station doesn't transmit anything except when it detects an AP on that
frequency, and even then, the station would follow the strictest txpower
limitations.

-- 
Regards,
Pavel Roskin


_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless
