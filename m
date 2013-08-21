Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58329 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab3HUIPe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 04:15:34 -0400
Message-ID: <1377072922.15268.4.camel@jlt4.sipsolutions.net> (sfid-20130821_101540_318952_978D2551)
Subject: Re: [PATCH 09/16] wcn36xx: Add smd.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: Joe Perches <joe@perches.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx@lists.infradead.org
Date: Wed, 21 Aug 2013 10:15:22 +0200
In-Reply-To: <CAFSJ42ZMk6sN6povWHkSodk0J7pBvyak8sH-MqNXVhi_iSmq9Q@mail.gmail.com> (sfid-20130821_095852_398872_A90920C7)
References: <1377020479-16935-1-git-send-email-k.eugene.e@gmail.com>
	 <1377020479-16935-10-git-send-email-k.eugene.e@gmail.com>
	 <1377022333.2016.59.camel@joe-AO722>
	 <CAFSJ42ZMk6sN6povWHkSodk0J7pBvyak8sH-MqNXVhi_iSmq9Q@mail.gmail.com>
	 (sfid-20130821_095852_398872_A90920C7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-08-21 at 09:58 +0200, Eugene Krasnikov wrote:
> 2013/8/20 Joe Perches <joe@perches.com>:
> > On Tue, 2013-08-20 at 19:41 +0200, Eugene Krasnikov wrote:
> >
> >> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> > []
> >> +int wcn36xx_smd_load_nv(struct wcn36xx *wcn)
> >> +{
> > []
> >> +             /* Add NV body itself */
> >> +             /* Rework me */
> >> +             memcpy(wcn->smd_buf + sizeof(msg_body),
> >> +                    (void *)(&nv_d->table) + fm_offset,
> >> +                    msg_body.nv_img_buffer_size);
> >
> > Does this really do what you want?
> >
> > Perhaps it should be:
> >
> >                 memcpy(wcn->smd_buf + sizeof(msg_body),
> >                        ((void *)&nv_d->table) + fm_offset,
> >                        msg_body.nv_img_buffer_size);
> >
> 
> Yes, this line is working. Tested it for ARM. Do you see any potential
> problems with this pointer operation?

It should really be u8* instead of void*, since void* pointer arithmetic
isn't really defined I think?

Other than that, this was just about precedence rules, and casts have a
higher precedence.

johannes

