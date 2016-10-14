Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58909 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756138AbcJNNMI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Oct 2016 09:12:08 -0400
Message-ID: <1476450678.31114.43.camel@sipsolutions.net> (sfid-20161014_151532_769653_3D72DBAB)
Subject: Re: [PATCH] mac80211: aes_ccm: move struct aead_req off the stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, luto@amacapital.net,
        sergey.senozhatsky.work@gmail.com, netdev@vger.kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        j@w1.fi
Date: Fri, 14 Oct 2016 15:11:18 +0200
In-Reply-To: <1476450635.31114.42.camel@sipsolutions.net> (sfid-20161014_151049_007103_7C55AE25)
References: <1476450540-1760-1-git-send-email-ard.biesheuvel@linaro.org>
         (sfid-20161014_150908_308224_F47D6BD7) <1476450635.31114.42.camel@sipsolutions.net>
         (sfid-20161014_151049_007103_7C55AE25)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-10-14 at 15:10 +0200, Johannes Berg wrote:
> > 
> > So use kzalloc
> 
> Do we really need kzalloc()? We have things on the stack right now,
> and don't initialize, so surely we don't really need to zero things? 

Err, never mind, I'm an idiot - we *do* initialize to 0, of course.

johannes
