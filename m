Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:42722 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754368AbbCFQNA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 11:13:00 -0500
Date: Fri, 6 Mar 2015 11:12:57 -0500
From: marco <marco@tampabay.rr.com>
To: wim torfs <wtorfs@gmail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: carl1970: monitor mode only displaying beacons/probs from APs?
Message-ID: <20150306161257.GA720@192.168.1.10> (sfid-20150306_171304_441504_FCC57873)
References: <20150304230225.J5EHX.13935.root@cdptpa-web27>
 <3859987.D1VAPy8h72@debian64>
 <54F93907.6020408@tampabay.rr.com>
 <54F974B2.5050604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54F974B2.5050604@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 06, 2015 at 10:34:42AM +0100, wim torfs wrote:
> Hi,
> 
> Perhaps a silly question, and I'm sure you already covered this, but I need
> to ask, just to be sure. Did you enable promiscuous mode to capture the data
> packets?
> 
> Could you elaborate on the employed method for capturing the data, it is
> difficult to make any suggestions without having knowledge about the used
> procedure.
> 
> Best Regards,
> Wim.
> 
>
Hello Wim,

Honestly, I've never seen promiscuous mode get me anything when doing
wireless sniffing; probably because I'm not associated with an AP.
That being said, I have tried that without any noticeable difference.

I use both wireshark and tcpdump for my testing.  I'm just looking for
wireless packets that one normally sees when doing wireless sniffing
(there is a lot of sta's / AP's around me) acks, CTS/RTS, various
management frames, etc.  The missing traffic is pretty obvious when
comparing to another working wifi stick (in my case 9khtc).

I guess if this is not an obvious problem, I can go bisect until I
find where the problem was introduced.  This was working fine in the
past.


Example:  carl9170
It seem like all the traffic I see is from AP's, no STA.  The three
types are all I ever see (1 data frame, and two mgmt frames, no
ctrl).

... -82dB signal antenna 5 Beacon (...) [1.0* 2.0* 2.0* 5...
... -81dB signal antenna 5 Beacon (...) [11.0* 11.0* 6....
... -57dB signal antenna 5 Beacon (...) [1.0* 2.0* 5.5* 11.0* ...
... -76dB signal antenna 5 Beacon (...) [1.0* 2.0* 5...
... -82dB signal antenna 5 Beacon (...) [1.0* 2.0* 2.0* 5...
... -82dB signal antenna 5 Probe Request () [1.0* 2.0* 5.5* 11.0...
... -57dB signal antenna 5 Beacon (...) [1.0* 2.0* 5.5* 11.0* ...
... -76dB signal antenna 5 Beacon (...) [1.0* 2.0* 5...
... -82dB signal antenna 5 Beacon (...) [1.0* 2.0* 2.0* 5...
... -83dB signal antenna 5 Beacon (...) [11.0* 11.0* 6....
... -82dB signal antenna 5 Beacon (...) [1.0* 2.0* 2.0* 5....
... -57dB signal antenna 5 Beacon (...) [1.0* 2.0* 5.5* 11.0* ...
... -76dB signal antenna 5 Beacon (...) [1.0* 2.0* 5...
... -83dB signal antenna 5 Beacon (...) [11.0* 11.0* 6....
... -74dB signal antenna 5 Data IV: c0 Pad 20 KeyID 1
... -74dB signal antenna 5 Beacon (...) [1.0* 2.0* 5.5* 11.0* ...
... -77dB signal antenna 5 Beacon (...) [1.0* 2.0* 5...
... -83dB signal antenna 5 Beacon (...) [1.0* 2.0* 2.0* 5...
... -82dB signal antenna 5 Beacon (...) [1.0* 2.0* 2.0* 5....


Example:  9k-htc
I see plenty of other frames (lots more in a larger sample)

... -75dB signal antenna 0 Unknown Ctrl Subtype 
... -74dB signal antenna 0 Beacon (...) [1.0* 2.0* 5
... -74dB signal antenna 0 Beacon (...) [11.0* 11.
... -74dB signal antenna 0 Beacon (...) [1.0* 2.0* 
... -76dB signal antenna 0 Beacon (...) [1.0* 2.0* 5.5* 
... -76dB signal antenna 0 Beacon (...) [1.0* 2.0* 2
... -77dB signal antenna 0 Beacon (...) [1.0*
... -72dB signal antenna 0 Beacon (...) [1.0* 2.
... -73dB signal antenna 0 [|802.11]
... -73dB signal antenna 0 Unknown Ctrl Subtype
... -73dB signal antenna 0 Power Save-Poll AID
... -72dB signal antenna 0 Beacon (...) [1.0* 2.0* 5
... -72dB signal antenna 0 Beacon (...) [1.0* 2.
... -73dB signal antenna 0 Beacon (...) [1.0* 2.0* 
... -75dB signal antenna 0 Beacon (...) ESS[|802.11]
... -76dB signal antenna 0 Beacon (...) [1.0* 2.0* 2
... -77dB signal antenna 0 CF Ack/Poll+QoS 
... -78dB signal antenna 0 Data IV:363bbb Pad 20 KeyID 2
... -78dB signal antenna 0 Beacon (...) [1.0*
... -73dB signal antenna 0 Beacon (...) [1.0* 2.
... -74dB signal antenna 0 Beacon (...) [1.0* 2.0* 2.
... -75dB signal antenna 0 Unknown Ctrl Subtype
... -75dB signal antenna 0 Unknown Ctrl Subtype


Regards,
Marco
