Return-path: <wireless-bounces@tuxdriver.com>
Received: from fencepost.gnu.org (fencepost.gnu.org [199.232.76.164])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0UMtCGA029937
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 17:55:43 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
 id 1HC1rd-0007Xc-RL	for wireless@lists.tuxdriver.org; Tue,
 30 Jan 2007 17:54:10 -0500
Date: Tue, 30 Jan 2007 17:54:56 -0500
From: Pavel Roskin <proski@gnu.org>
Subject: Re: Getting dscape running
In-reply-to: <9e4733910701301436m2bdb903cpb2089a1c395b489c@mail.gmail.com>
Sender: wireless-bounces@tuxdriver.com
To: Jon Smirl <jonsmirl@gmail.com>
Cc: wireless@lists.tuxdriver.org
Errors-to: wireless-bounces@tuxdriver.com
Message-id: <1170197696.11455.18.camel@dv>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
References: <9e4733910701301415p2ce1042aqcd833c732bc761cb@mail.gmail.com>
 <1170195897.11455.6.camel@dv>
 <9e4733910701301436m2bdb903cpb2089a1c395b489c@mail.gmail.com>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>

On Tue, 2007-01-30 at 17:36 -0500, Jon Smirl wrote:
> Here's the same rt2570 device using the ifconfig commands. I was
> trying to get NetworkManager running on it in case it was doing
> something that I wasn't doing manually. Some is not quite right with
> the WEP exchange.
> 
> jonsmirl@jonsmirl:/extra/wireless-dev/net/d80211$ iwconfig
> lo        no wireless extensions.
> 
> eth0      no wireless extensions.
> 
> wmaster0  IEEE 802.11g  Frequency:2.412 GHz
>           RTS thr:off   Fragment thr=2346 B
> 
> wlan0     IEEE 802.11g  ESSID:""
>           Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated
>           RTS thr:off   Fragment thr=2346 B
>           Link Quality:0  Signal level:0  Noise level:0
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> 
> jonsmirl@jonsmirl:/extra/wireless-dev/net/d80211$ sudo iwconfig wlan0 channel 1
> jonsmirl@jonsmirl:/extra/wireless-dev/net/d80211$ sudo iwconfig wlan0
> key F491B8B905
> jonsmirl@jonsmirl:/extra/wireless-dev/net/d80211$ sudo iwconfig wlan0
> essid Smirl
> jonsmirl@jonsmirl:/extra/wireless-dev/net/d80211$ sudo iwconfig wlan0
> ap 00:11:95:18:15:31

It would be interesting to look at the iwconfig output at this point.
If "Link Quality" is still 0, there is no much use in running dhclient.
Run iwconfig as root so you can verify that the WEP key is correct.

> I'm unable to connect to it using WEP. The same device works on the Intel stack.

And how about connections without WEP?

> wmaster0: TX to low-level driver (len=26) FC=0x00a0 DUR=0x013a
> A1=00:11:95:18:15:31 A2=00:15:e9:2d:76:57 A3=00:11:95:18:15:31
> wlan0: privacy configuration mismatch and mixed-cell disabled - disassociate

My understanding of the code that prints the above is that either the AP
doesn't support WEP or the client doesn't have WEP enabled.  That can
include the case when some other encryption algorithm is active.

Just in case, please make sure your .config enables CONFIG_CRYPTO_ECB
and CONFIG_CRYPTO_ARC4.

-- 
Regards,
Pavel Roskin


_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless
