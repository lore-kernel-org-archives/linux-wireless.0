Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.176]:33345 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbYKAV0d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 17:26:33 -0400
Received: by el-out-1112.google.com with SMTP id z25so942234ele.1
        for <linux-wireless@vger.kernel.org>; Sat, 01 Nov 2008 14:26:31 -0700 (PDT)
Message-ID: <43e72e890811011419k460b11e0he08d66022cbd606e@mail.gmail.com> (sfid-20081101_222653_039951_8D4E9B3B)
Date: Sat, 1 Nov 2008 14:19:55 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: tim.gardner@canonical.com
Subject: Re: wireless-testing commit eb9d4e8399181357cb6f6625ba7f849987432c6c causes stalls
Cc: mick@madwifi.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Bob Copeland" <me@bobcopeland.com>
In-Reply-To: <4908B754.1050400@tpi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <4908B754.1050400@tpi.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 29, 2008 at 12:19 PM, Tim Gardner <tcanonical@tpi.com> wrote:
> This commit 'ath5k: Update interrupt masking code' causes stalls under
> load when built using compat-wireless on 2.6.27. There is no output from
> dmesg, but it occasionally recovers and moves a few more packets before
> stalling again. Luis suggested reverting
> eb9d4e8399181357cb6f6625ba7f849987432c6c which I did. Now it appears to
> work normally.
>
> I also think this patch should be broken into multiple pieces. There
> appear to be at least 3 functional changes addressed in this single patch.

Agreed, I just tested with the latest wireless-testing and the issue
is still present. I reviewed the commit but its a big too large to pin
point the exact issue, my AR5414 goes up but then quickly becomes
unusable. Nick how about we revert this and you can then split this up
into a good number of patches to make the review easier and also to be
able to pin point the exact issue better?

The SHA1 remains the same but just in case the title of the patch is:

   ath5k: Update interrupt masking code

With it reverted I'm cruising and can ditch MadWifi completely, which
is the idea.

  Luis
