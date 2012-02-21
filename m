Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34414 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab2BUNGC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 08:06:02 -0500
Subject: Re: [PATCH] mac80211: Fix the generation of PREQs in proactive
 RANN mechanism of HWMP
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org
In-Reply-To: <1329829506.3361.6.camel@jlt3.sipsolutions.net> (sfid-20120221_140516_491524_D9C8E35C)
References: <1329850383-31837-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20120221_111128_325359_5A17F42A)  <1329829506.3361.6.camel@jlt3.sipsolutions.net>
	 (sfid-20120221_140516_491524_D9C8E35C)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Feb 2012 14:06:00 +0100
Message-ID: <1329829560.3361.7.camel@jlt3.sipsolutions.net> (sfid-20120221_140605_996516_6A5846CF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-02-21 at 14:05 +0100, Johannes Berg wrote:
> On Wed, 2012-02-22 at 02:53 +0800, Chun-Yeow Yeoh wrote:
> 
> > +++ b/net/mac80211/mesh_hwmp.c
> > @@ -590,12 +590,22 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
> >  		flags = PREQ_IE_FLAGS(preq_elem);
> >  		preq_id = PREQ_IE_PREQ_ID(preq_elem);
> >  		hopcount = PREQ_IE_HOPCOUNT(preq_elem) + 1;
> > +		if (mpath && mpath->is_root) {
> > +			mesh_path_sel_frame_tx(MPATH_PREQ, flags, orig_addr,
> > +				cpu_to_le32(orig_sn), target_flags, target_addr,
> > +				cpu_to_le32(target_sn), mpath->rann_snd_addr,
> > +				hopcount, ttl, cpu_to_le32(lifetime),
> > +				cpu_to_le32(metric), cpu_to_le32(preq_id),
> > +				sdata);
> > +			goto endpreq;
> > +		}
> >  		mesh_path_sel_frame_tx(MPATH_PREQ, flags, orig_addr,
> >  				cpu_to_le32(orig_sn), target_flags, target_addr,
> >  				cpu_to_le32(target_sn), broadcast_addr,
> >  				hopcount, ttl, cpu_to_le32(lifetime),
> >  				cpu_to_le32(metric), cpu_to_le32(preq_id),
> >  				sdata);
> > +endpreq:
> 
> maybe "else {..." instead of the goto?

actually, since only one parameter is different, it's probably better to
just introduce a local variable for that parameter.

johannes

