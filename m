Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:40542 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab3JLTRv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Oct 2013 15:17:51 -0400
Received: by mail-vc0-f177.google.com with SMTP id hv10so3695762vcb.8
        for <linux-wireless@vger.kernel.org>; Sat, 12 Oct 2013 12:17:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1381602356.14243.4.camel@jlt4.sipsolutions.net>
References: <525720d0.6xVLGLwuRrqxqOBI%fengguang.wu@intel.com>
	<20131011014733.GD11191@localhost>
	<CAFSJ42aa_-DTHDxkRDM+0bm9052ree__K54CRm749SeQPDHwRw@mail.gmail.com>
	<1381476265.14293.0.camel@jlt4.sipsolutions.net>
	<CAFSJ42Y3x9bzKO8jo-n8Vn7ei38FkYVqW5Gog+_pa_j83ZUXhw@mail.gmail.com>
	<1381602356.14243.4.camel@jlt4.sipsolutions.net>
Date: Sat, 12 Oct 2013 20:17:49 +0100
Message-ID: <CAFSJ42Z2E8ivgjm8jw4xJ8pvp=NViNDOaMKy4yR7qKGjEVioSQ@mail.gmail.com> (sfid-20131012_211807_174925_06571DF2)
Subject: Re: [wireless-next:master 82/98] drivers/net/wireless/ath/wcn36xx/wcn36xx.h:88:24:
 sparse: incorrect type in assignment (different base types)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Fengguang Wu <fengguang.wu@intel.com>, kbuild-all@01.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx <wcn36xx@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> $ sparse --version
> v0.4.4-133-g5449cfb

My is: sparse --version
v0.4.5-rc1


> Hard to believe - did you pass the CF= on the command line? I suggest
>
> ccflags-y += -D__CHECK_ENDIAN__

Agree that it's not a version difference :) Yes , i set check endian.
Weird, will try to modify makefile and see if that helps.


> Also, code might be fine, but buff_to_be() is still not a good idea
> since it breaks all endian annotation.

Could you please explain in more details how does buff_to_be break
endian annotation?


> Also, I suggested to run smatch, I guess you never did:

I ran it and even fixed some of the errors. These errors i might just
missed because of the output is flooded with messages like:
drivers/net/wireless/ath/wcn36xx/main.c:24 (null)() info: ignoring
unreachable code.

Thanx for pointing to these warnings.

On Sat, Oct 12, 2013 at 7:25 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2013-10-11 at 21:39 +0100, Eugene Krasnikov wrote:
>
>> Do you see the same warning?
>
> Yes
>
>> With the latest sparse i do not see this
>> warning.
>
> $ sparse --version
> v0.4.4-133-g5449cfb
>
>> I assume this warning depends on sparse version since with my
>> environment it does not pop up. Also from code perspective it looks
>> fine. Any ideas?:)
>
> Hard to believe - did you pass the CF= on the command line? I suggest
>
> ccflags-y += -D__CHECK_ENDIAN__
>
> in your Makefile.
>
> Also, code might be fine, but buff_to_be() is still not a good idea
> since it breaks all endian annotation.
>
> Also, I suggested to run smatch, I guess you never did:
> drivers/net/wireless/ath/wcn36xx/smd.c:1314 wcn36xx_smd_send_beacon() warn: inconsistent returns mutex:&wcn->hal_mutex: locked (1289 [(-12)]) unlocked (1314 [0], 1314 [s32min-(-1),1-s32max])
> drivers/net/wireless/ath/wcn36xx/smd.c:1357 wcn36xx_smd_update_proberesp_tmpl() warn: inconsistent returns mutex:&wcn->hal_mutex: locked (1330 [(-7)]) unlocked (1357 [0], 1357 [s32min-(-1),1-s32max])
> drivers/net/wireless/ath/wcn36xx/smd.c:1626 wcn36xx_smd_keep_alive_req() warn: inconsistent returns mutex:&wcn->hal_mutex: locked (1609 [(-22)]) unlocked (1626 [0], 1626 [s32min-(-1),1-s32max])
> drivers/net/wireless/ath/wcn36xx/smd.c:2041 wcn36xx_smd_rsp_process() error: potential null dereference 'msg_ind'.  (kmalloc returns null)
>
> johannes
>



-- 
Best regards,
Eugene
