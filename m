Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:22224 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbZCMSvX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 14:51:23 -0400
Received: by yx-out-2324.google.com with SMTP id 8so383389yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2009 11:51:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1236941908.5235.27.camel@johannes.local>
References: <1236939917.5235.7.camel@johannes.local>
	 <1236941058.5235.12.camel@johannes.local>
	 <1236941339.5235.14.camel@johannes.local>
	 <1236941908.5235.27.camel@johannes.local>
Date: Fri, 13 Mar 2009 14:51:20 -0400
Message-ID: <b6c5339f0903131151m2dc43fbo52ace9d9070096c@mail.gmail.com> (sfid-20090313_195129_820956_2D983446)
Subject: Re: [PATCH v2] mac80211: resume properly, add suspend/resume test
From: Bob Copeland <bcopeland@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 13, 2009 at 6:58 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> ath9k survives ping -f without even blinking.
>
> Actually, not quite:
>
> [ =A0289.753866]
> [ =A0289.753869] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ =A0289.754164] [ INFO: inconsistent lock state ]
> [ =A0289.754372] 2.6.29-rc7-wl-17155-g2f7ab92-dirty #29
> [ =A0289.754598] ---------------------------------
> [ =A0289.754805] inconsistent {in-softirq-W} -> {softirq-on-W} usage.

[softirq-on-W stack looks like:

  sta_notify
    ath_node_detach
      ath_tx_node_cleanup
        spin_lock()

vs the ath9k_tx_tasklet]

> Looks like we need to disable BHs for the sta functions or something?
>
> johannes

Yup... or pm can take sta_lock with spin_lock_irqsave() like the other
callers of sta_notify.

=46eel free to add my Acked-by on both the PM patches.  I'd been using
CONFIG_PM_DEBUG to simulate suspend/resume but since you have to
do 'devices' anyway to get the desired effect, the debug file here
is nicer.

--=20
Bob Copeland %% www.bobcopeland.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
