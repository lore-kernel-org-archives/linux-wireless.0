Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-160-52.gdrpmi.dsl-w.verizon.net ([71.115.160.52]:35426
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbZCPB6o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2009 21:58:44 -0400
Message-ID: <49BDB24D.3030508@erley.org> (sfid-20090316_025901_731508_20FB6551)
Date: Sun, 15 Mar 2009 21:58:37 -0400
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: Antonio Marques <froz@icix.org>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rt2x00 mesh support
References: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org> <467E98EC-F5B1-4D79-914E-35E021125E37@icix.org> <594B4EB2-FE87-4756-B016-C83083EF415B@icix.org> <200903151445.01344.IvDoorn@gmail.com>
In-Reply-To: <200903151445.01344.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn wrote:
> On Sunday 15 March 2009, Antonio Marques wrote:
>> Upon further investigation, beaconing does not work after configuring
>> an interface in mesh point mode but running 'iwlist mesh scan'
>> triggers something in the driver that enables beaconing.
>> After executing this command beacons are generated and correctly
>> received at other nodes.
> 
> Thats odd, but very interesting :)
> Could you enable debugfs and CONFIG_RT2X00_LIB_DEBUGFS and
> use the script from http://kernel.org/pub/linux/kernel/people/ivd/tools/rt2x00_regdump.sh
> to create a register dump before running 'iwlist mesh scan' and afterwards.
> (So basically when beaconing is broken and when it is working).
> 
> Thanks,
> 
> Ivo

I get identical behavior with the patch I'm about to RFC for ath9k to enable 
mesh mode.  I just want to test that it works with my b43, rt61pci, and 
rt2x00usb devices.  Of the 4, ONLY b43 enables beaconing for mesh mode on
interface up.  I suspect my ath5k one will exhibit similar behavior.  I've 
reviewed the b43 code about 100 times during the writing of my patch for ath9k
and I can't spot what it's doing that's so different. 

Pat 
