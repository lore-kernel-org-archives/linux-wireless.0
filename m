Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51637 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab3JLS0L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Oct 2013 14:26:11 -0400
Message-ID: <1381602356.14243.4.camel@jlt4.sipsolutions.net> (sfid-20131012_202626_583146_18FE8807)
Subject: Re: [wireless-next:master 82/98]
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h:88:24: sparse: incorrect type in
 assignment (different base types)
From: Johannes Berg <johannes@sipsolutions.net>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, kbuild-all@01.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx <wcn36xx@lists.infradead.org>
Date: Sat, 12 Oct 2013 20:25:56 +0200
In-Reply-To: <CAFSJ42Y3x9bzKO8jo-n8Vn7ei38FkYVqW5Gog+_pa_j83ZUXhw@mail.gmail.com> (sfid-20131011_223914_611136_4CE5E6C4)
References: <525720d0.6xVLGLwuRrqxqOBI%fengguang.wu@intel.com>
	 <20131011014733.GD11191@localhost>
	 <CAFSJ42aa_-DTHDxkRDM+0bm9052ree__K54CRm749SeQPDHwRw@mail.gmail.com>
	 <1381476265.14293.0.camel@jlt4.sipsolutions.net>
	 <CAFSJ42Y3x9bzKO8jo-n8Vn7ei38FkYVqW5Gog+_pa_j83ZUXhw@mail.gmail.com>
	 (sfid-20131011_223914_611136_4CE5E6C4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-10-11 at 21:39 +0100, Eugene Krasnikov wrote:

> Do you see the same warning? 

Yes

> With the latest sparse i do not see this
> warning. 

$ sparse --version
v0.4.4-133-g5449cfb

> I assume this warning depends on sparse version since with my
> environment it does not pop up. Also from code perspective it looks
> fine. Any ideas?:)

Hard to believe - did you pass the CF= on the command line? I suggest

ccflags-y += -D__CHECK_ENDIAN__

in your Makefile.

Also, code might be fine, but buff_to_be() is still not a good idea
since it breaks all endian annotation.

Also, I suggested to run smatch, I guess you never did:
drivers/net/wireless/ath/wcn36xx/smd.c:1314 wcn36xx_smd_send_beacon() warn: inconsistent returns mutex:&wcn->hal_mutex: locked (1289 [(-12)]) unlocked (1314 [0], 1314 [s32min-(-1),1-s32max])
drivers/net/wireless/ath/wcn36xx/smd.c:1357 wcn36xx_smd_update_proberesp_tmpl() warn: inconsistent returns mutex:&wcn->hal_mutex: locked (1330 [(-7)]) unlocked (1357 [0], 1357 [s32min-(-1),1-s32max])
drivers/net/wireless/ath/wcn36xx/smd.c:1626 wcn36xx_smd_keep_alive_req() warn: inconsistent returns mutex:&wcn->hal_mutex: locked (1609 [(-22)]) unlocked (1626 [0], 1626 [s32min-(-1),1-s32max])
drivers/net/wireless/ath/wcn36xx/smd.c:2041 wcn36xx_smd_rsp_process() error: potential null dereference 'msg_ind'.  (kmalloc returns null)

johannes

