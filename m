Return-path: <wireless-bounces@tuxdriver.com>
Received: from mail4.sea5.speakeasy.net (mail4.sea5.speakeasy.net
	[69.17.117.6])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0V2mDGQ003836
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 21:48:40 -0500
Date: Tue, 30 Jan 2007 18:48:07 -0800
From: Jouni Malinen <jkmaline@cc.hut.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [RFC] cfg80211 merge
Message-ID: <20070131024807.GA7061@jm.kir.nu>
References: <20070131013717.GA28076@tuxdriver.com>
MIME-Version: 1.0
In-Reply-To: <20070131013717.GA28076@tuxdriver.com>
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

On Tue, Jan 30, 2007 at 08:37:17PM -0500, John W. Linville wrote:

> In London we agreed that it would be good to go ahead and merge
> cfg80211.

> Let me know if I've left anything out, screwed anything up, or if
> you no longer think a cfg80211 merge is appropriate at this time.

Merge to the mainline kernel? Do we really believe that this is ready
for this now? I have to admit that I have not personally tested this,
but based on what I've heard, this does not seem to be complete yet and
there are some areas that may need to be changed or at least there has
been some comments on desire to change something in the design, e.g.,
for the MLME requests and recently for the SSID handling. In addition, I
have not heard of any user space programs that would actually be using
this interface.

What would happen if this gets merged in now and some major problems are
found when people start implementing programs using this interface?
Would we be stuck with maintaining this user space interface as-is for
years without having a chance of easily fixing something?

I'm all for getting this into the mainline kernel as soon as possible,
but I do not think that this should happen before there are user space
programs that demonstrate that cfg80211 can be used without problems and
that the kernel side implementation is complete enough to allow some
meaningful operations to be completed with cfg80211 (likely with WEXT
disabled, i.e., cfg80211 being feature complete for, say, WPA
authentication).

I have been waiting for cfg80211 to become bit more stable and
functional before implementing support for it as an alternative driver
interface in wpa_supplicant. Based on what I heard in London, this would
not work yet, but maybe now would be a suitable time to at least start
experimenting with this by making a copy of the WEXT interface code and
starting to change operations one by one from WEXT to cfg80211 based on
what actually is available in the kernel.

-- 
Jouni Malinen                                            PGP id EFC895FA
_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless
