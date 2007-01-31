Return-path: <wireless-bounces@tuxdriver.com>
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.231])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0V0Jpi0032381	for
 <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 19:20:16 -0500
Received: by wr-out-0506.google.com with SMTP id 36so38739wra	for
 <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 16:19:46 -0800 (PST)
Date: Tue, 30 Jan 2007 19:19:46 -0500
From: Jon Smirl <jonsmirl@gmail.com>
Subject: Re: Getting dscape running
In-reply-to: <1170197696.11455.18.camel@dv>
Sender: wireless-bounces@tuxdriver.com
To: Pavel Roskin <proski@gnu.org>
Cc: wireless@lists.tuxdriver.org
Errors-to: wireless-bounces@tuxdriver.com
Message-id: <9e4733910701301619j3b903460r4a3447ef10b46a47@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
References: <9e4733910701301415p2ce1042aqcd833c732bc761cb@mail.gmail.com>
 <1170195897.11455.6.camel@dv>
 <9e4733910701301436m2bdb903cpb2089a1c395b489c@mail.gmail.com>
 <1170197696.11455.18.camel@dv>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>

On 1/30/07, Pavel Roskin <proski@gnu.org> wrote:
> > I'm unable to connect to it using WEP. The same device works on the Intel stack.
>
> And how about connections without WEP?
>
> > wmaster0: TX to low-level driver (len=26) FC=0x00a0 DUR=0x013a
> > A1=00:11:95:18:15:31 A2=00:15:e9:2d:76:57 A3=00:11:95:18:15:31
> > wlan0: privacy configuration mismatch and mixed-cell disabled - disassociate
>
> My understanding of the code that prints the above is that either the AP
> doesn't support WEP or the client doesn't have WEP enabled.  That can
> include the case when some other encryption algorithm is active.

I think I've located what the problem is. NetworkManager was hanging
around as a deamon and changing my encryption settings improperly
probably because of the NULL gobject problem. I fixed my system to not
run NM, rebooted and now I can connect.

> Just in case, please make sure your .config enables CONFIG_CRYPTO_ECB
> and CONFIG_CRYPTO_ARC4.
>
> --
> Regards,
> Pavel Roskin
>
>
>


-- 
Jon Smirl
jonsmirl@gmail.com
_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless
