Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49890 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab0JNXqi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 19:46:38 -0400
Received: by gxk6 with SMTP id 6so100463gxk.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 16:46:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CB78870.8040207@candelatech.com>
References: <4CAE1DFB.303@candelatech.com>
	<1286479642.20974.32.camel@jlt3.sipsolutions.net>
	<AANLkTimxp703Gy_Atg8=wpFszRDR=OJCXwOUKRh-a-d7@mail.gmail.com>
	<AANLkTi=t-P_5c14brJohM8UgxeOknv+3syO=7W=ix6qf@mail.gmail.com>
	<AANLkTinC46a+nE-XOQuBCmRJwjzgh24uC7ZJ7HtbVHnT@mail.gmail.com>
	<4CB378CD.1080800@candelatech.com>
	<AANLkTim42zmDwf744BCrPwa1kT5ph57bNMyvSyOpesVv@mail.gmail.com>
	<4CB3D598.7050904@candelatech.com>
	<AANLkTimPEg3ZU8CQUXfdpGdfbmhdE9O=GNY=g9gysTo4@mail.gmail.com>
	<4CB4AA89.1070009@candelatech.com>
	<20101013053141.GA15798@vasanth-laptop>
	<4CB5E0A8.5020502@candelatech.com>
	<AANLkTimp_GSwwX_RnQSyN9QNe55HQ+0HZJ1yd8Xp+dWG@mail.gmail.com>
	<AANLkTinyVqdgPqzpyihuaPtVVqDmzj-ZbXzQ-4qdA2yH@mail.gmail.com>
	<4CB78870.8040207@candelatech.com>
Date: Fri, 15 Oct 2010 01:46:37 +0200
Message-ID: <AANLkTimqX5E33eTPYiei4GcCYocbs8-zceCARG+5t98B@mail.gmail.com>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Ben Greear <greearb@candelatech.com>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/10/15 Ben Greear <greearb@candelatech.com>:
> I tried the patch below, and it didn't seem to help.  Might even
> have hurt..as it died on divide-by-zero error:

Hmm, looks like the ani code got a zero listen time from the hw...
That just might mean that the DMA actually hits one of these
descriptors. :)

I'll send a patch for the div-by-zero in a minute, and then perhaps we
can narrow it down to which one of these descriptors is actually being
used by DMA when it really shouldn't be?

/Björn
