Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gondor.com ([212.117.64.182]:4682 "EHLO moria.gondor.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757239AbYCXANN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Mar 2008 20:13:13 -0400
Date: Mon, 24 Mar 2008 01:10:44 +0100
From: Jan Niehusmann <jan@gondor.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] mac80211: trigger ieee80211_sta_work after opening
	interface
Message-ID: <20080324001043.GB5389@x61s.gondor.com> (sfid-20080324_001324_537312_4703B6D4)
References: <20080323192355.GA5773@x61s.gondor.com> <1206310595.16475.190.camel@johannes.berg> <1ba2fa240803231528i4fc38343ifb49d44f5072c882@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240803231528i4fc38343ifb49d44f5072c882@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 24, 2008 at 12:28:07AM +0200, Tomas Winkler wrote:
> Why should be possible to configure device when it's not up. Shouldn't
> be there some order in which things are happening?

I don't know if it should be possible, but the debian ifup scripts seem to
do it that way. I just configured the interface in /etc/network/interfaces
using the wireless_* config options, and 'ifup wlan0' fails to start the
network as the interface doesn't associate. It does work if I manually
call 'iwconfig wlan0 ap any' after the scripts brought the interface up.

With the patch, 'ifup wlan0' works perfectly for me.

Also, I'm not the only one with this problem, as I found exactly the
same hint with google:
http://bayleshanks.com/tips-computer-lenovoX61t-gnuLinuxSetup
"I found that I have to do "iwconfig wlan0 ap any" before it will
associate with my router. Dunno if that's a general problem or if I did
something wrong in /etc/network/interfaces."

(Please not that I'm using a Lenovo x61s, and the mentioned link talks
about an x61t, which are quite similar. So it may be that this behaviour
is only visible with some hardware configurations.)

Jan

