Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58509 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab1G2D2D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 23:28:03 -0400
Received: by iyb12 with SMTP id 12so3524172iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jul 2011 20:28:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E3222B6.1010904@gnu.org>
References: <20110729025007.7889.19879.stgit@mj.roinet.com> <4E3222B6.1010904@gnu.org>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 29 Jul 2011 13:27:42 +1000
Message-ID: <CAGRGNgWo=jgOwffbvCL5SDA6TD=cKUheObSM=23+ZTNCqH+-GQ@mail.gmail.com> (sfid-20110729_052808_140623_FF548066)
Subject: Re: [PATCH] lib80211: call try_module_get() in lib80211_get_crypto_ops()
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel,

On Fri, Jul 29, 2011 at 13:02, Pavel Roskin <proski@gnu.org> wrote:
> lib80211 has a terrible API, and the module referencing is split between
> lib80211 and the callers.  Everything is too complicated.  Keys may be freed
> asynchronously.  Module referencing is tied to the keys and not to the ops.
>  I've seen the reference count for lib80211_crypt_ccmp to underflow and
> become 4294967295 or something.

If I recall correctly, lib80211 is the last remainder of the
pre-mac80211 wireless stack. It should be annihilated with extreme
prejudice, but the intel centrino 2xxx drivers are so interwoven with
it that extracting them would be a pain in the ass - and given that
nobody who has those parts really cares, this hasn't happened.

That said, bugs are bugs and they should be fixed.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
