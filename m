Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from europa.telenet-ops.be ([195.130.137.75]:58002 "EHLO
	europa.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbXJWLk7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2007 07:40:59 -0400
Message-ID: <471DDDD0.4060007@telenet.be> (sfid-20071023_124103_929472_08D811A8)
Date: Tue, 23 Oct 2007 13:41:04 +0200
From: Ian Schram <ischram@telenet.be>
MIME-Version: 1.0
To: Norbert Preining <preining@logic.at>
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
Subject: Re: [ipw3945-devel] [RFC][PATCH] iwlwifi using mac80211_leds
References: <47164DA9.3050001@telenet.be>  <9f50a7a00710222311u7ae17958w596c3d579fb31536@mail.gmail.com> <1193120114.3069.256.camel@debian.sh.intel.com> <loom.20071023T104428-443@post.gmane.org>
In-Reply-To: <loom.20071023T104428-443@post.gmane.org>
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Norbert Preining wrote:
> Zhu Yi <yi.zhu@...> writes:
> aven't have enough time to review this patch these days. Will
>> try to do it next week. But any test are always welcome!
> 
> I would like to, is there a way to patch this into the git sources?
the intellinuxwireless.org gits? to make it work it would require an update
of the mac80211 package, and compatibility with older kernels is probably
pretty nasty.

> 
> I am running 2.6.23 with latest iwlwifi git sources.
> 
> I patched the git sources and started compiling with -DCONFIG_IWLWIFI_LEDS=y but
> the compile boiled out with:
> /src/wlan/iwlwifi/foo/compatible/iwl3945-base.c:6218: error: implicit
> declaration of function 'ieee80211_get_assoc_led_name'
> (and some more warnings).
> 
the association led is only in the very latest git sources, i'm guessing only
wireless-2.6 for now.

(also i have learned that i forgot to ifdef the INIT_DELAYED_WORK, I must really try to
beat this inability of sending a patch right the first time round)

i bet an iwl_is_ready(priv) call in the delayed work wouldn't hurt either,
anyway. It works for me feel free to improve it. Or wait until one of
seasoned developers, has no higher priority items on their list.

> Is there anything I can do to test it?
> 
> Best wishes
> 
> Norbert
> 

I'll try to send a patch a bit later today to fix a few of the outstanding issues.
