Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.236]:33890 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbYB0Dvs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 22:51:48 -0500
Received: by wr-out-0506.google.com with SMTP id c48so3807511wra.23
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2008 19:51:47 -0800 (PST)
Message-ID: <43e72e890802261951w17484becj34d0c469100e21d2@mail.gmail.com> (sfid-20080227_035151_196151_758F2F75)
Date: Tue, 26 Feb 2008 22:51:47 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Thomas Novin" <thnov@xyz.pp.se>
Subject: Re: 'make unload' fails if you run Ubuntu Hardy
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1203885279.7537.1.camel@pc-thnov-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1203885279.7537.1.camel@pc-thnov-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 24, 2008 at 3:34 PM, Thomas Novin <thnov@xyz.pp.se> wrote:
> Hello
>
>  I have just installed the latest compat-wireless system and 'make
>  unload' failed for me.
>
>  thnov@pc-thnov-ubuntu:~/src/compat-wireless-2.6$ sudo make unload
>  Unloading iwl3945...
>  Unloading mac80211...
>  Unloading cfg80211...
>  FATAL: Module cfg80211 is in use.
>  make: *** [unload] Error 1
>  thnov@pc-thnov-ubuntu:~/src/compat-wireless-2.6$ lsmod | grep iwl
>  iwlwifi_mac80211      220004  0
>  cfg80211               15112  1 iwlwifi_mac80211
>  thnov@pc-thnov-ubuntu:~/src/compat-wireless-2.6$ sudo modprobe -r
>  iwlwifi_mac80211
>  thnov@pc-thnov-ubuntu:~/src/compat-wireless-2.6$ sudo make unload
>  thnov@pc-thnov-ubuntu:~/src/compat-wireless-2.6$
>
>  So by manually unloading iwlwifi_mac80211 I managed to get past this.

Got it, fixed and pushed.

Thanks,

  Luis
