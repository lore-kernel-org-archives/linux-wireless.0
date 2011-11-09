Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:44676 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab1KIHzK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 02:55:10 -0500
From: "Elias, Ilan" <ilane@ti.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
CC: "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"samuel@sortiz.org" <samuel@sortiz.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v3 3/3] NFC: Check if NCI data flow control is used
Date: Wed, 9 Nov 2011 07:54:52 +0000
Message-ID: <B30D1FD582D6484ABF57420512E58035F74B@DNCE03.ent.ti.com> (sfid-20111109_085513_970943_AFAABF2F)
References: <1320152097-2711-1-git-send-email-ilane@ti.com>
	<1320152097-2711-4-git-send-email-ilane@ti.com>
 <CAK3JMAbtL1wmsY3d9phV+nCKRnH8sFdpPgKybxcAKmsfu1DDSA@mail.gmail.com>
In-Reply-To: <CAK3JMAbtL1wmsY3d9phV+nCKRnH8sFdpPgKybxcAKmsfu1DDSA@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Lauro, 

> > -               atomic_dec(&ndev->credits_cnt);
> > +               /* Check if data flow control is used */
> > +               if (atomic_read(&ndev->credits_cnt) != 0xff)
> > +                       atomic_dec(&ndev->credits_cnt);
> 
> It would be better to replace the 0xff by a define.
OK, I'll use a define instead of 0xff.

> 
> Lauro
> 

Thanks & BR,
Ilan
