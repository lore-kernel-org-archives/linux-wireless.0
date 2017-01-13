Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50476 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751442AbdAMLDk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 06:03:40 -0500
Message-ID: <1484302390.27366.0.camel@sipsolutions.net> (sfid-20170113_120345_583276_E1E8FAED)
Subject: Re: [PATCH] mac80211: prevent skb/txq mismatch
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Ben Greear <greearb@candelatech.com>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Date: Fri, 13 Jan 2017 11:13:10 +0100
In-Reply-To: <CA+BoTQnA4X+OPC2eFQO9tj+a+-z=_FTKA6UR_uJAUrQvzjZZ8Q@mail.gmail.com> (sfid-20170113_100443_344461_0D63BB30)
References: <1484231321-3179-1-git-send-email-michal.kazior@tieto.com>
         <1484295383.19860.7.camel@sipsolutions.net>
         <CA+BoTQnA4X+OPC2eFQO9tj+a+-z=_FTKA6UR_uJAUrQvzjZZ8Q@mail.gmail.com>
         (sfid-20170113_100443_344461_0D63BB30)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > What I don't understand - and you haven't really described - is how
> > the changes fix it? Could you resend with a paragraph added that
> > explains that?
> 
> "Since downgrading unicast traffic to vif->txq must not be done
> there's no txq to put a frame on if sta->uploaded is false. Therefore
> the code is made to fall back to regular tx() op path if the
> described condition is hit. " -- is this sufficient?

Makes sense.

> > Also, you're adding a test:
> > 
> > >       if (sta && !sta->uploaded)
> > 
> > but couldn't do move that into the existing "if (sta)" block?
> > Everything before that only ever returns NULL anyway.
> 
> Good point. It makes more sense to put the sta->uploaded check in if
> (sta) block. I'll move it.
> 

Ok, thanks.

johannes
