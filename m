Return-path: <wireless-bounces@tuxdriver.com>
Received: from mail.suse.cz (styx.suse.cz [82.119.242.94])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0VHbI3D004822
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <wireless@lists.tuxdriver.org>; Wed, 31 Jan 2007 12:37:44 -0500
Date: Wed, 31 Jan 2007 18:37:13 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: [RFC PATCH 1/3] cfg80211 and nl80211
Message-ID: <20070131183713.10999c74@griffin.suse.cz>
In-Reply-To: <200701302146.05289.flamingice@sourmilk.net>
References: <20070131013717.GA28076@tuxdriver.com>
	<20070131013840.GB28076@tuxdriver.com>
	<200701302146.05289.flamingice@sourmilk.net>
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

On Tue, 30 Jan 2007 21:46:01 -0500, Michael Wu wrote:
> I think drivers that currently support frame injection do it by allowing TX on 
> a monitor interface w/ AVS or radiotap header. I would rather have this than 
> requiring the use of NL80211 to inject frames since userspace won't have to 
> do as much to continue supporting frame injection. It also makes more sense 
> to me. Status notification can be done by a 802.11 ACK frame. Radiotap might 
> need to be extended to support toggling the ACK frame reporting for TX and 
> whatever else userspace wants to set.

Please, don't do that. You need to get a success/failure report from
the driver/stack. Doing that by dumping fake frames through the network
interfaces isn't something I could consider as a right behaviour. Also,
you need to match the sent frame and the report from the driver. This
gets really tricky when you use network interfaces.

 Jiri

-- 
Jiri Benc
SUSE Labs
_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless
