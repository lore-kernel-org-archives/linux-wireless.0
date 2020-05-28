Return-Path: <SRS0=UQ4x=7K=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC576C433DF
	for <linux-wireless@archiver.kernel.org>; Thu, 28 May 2020 17:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9444B2072D
	for <linux-wireless@archiver.kernel.org>; Thu, 28 May 2020 17:53:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405638AbgE1Rxf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 May 2020 13:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405636AbgE1Rxe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 May 2020 13:53:34 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA85C08C5C6
        for <linux-wireless@vger.kernel.org>; Thu, 28 May 2020 10:53:30 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jeMie-0051Gn-Bh; Thu, 28 May 2020 19:53:28 +0200
Message-ID: <1d4ce7f55e902f628149349a202faa64a3b663cb.camel@sipsolutions.net>
Subject: Re: [PATCH 12/24] mac80211: avoid using ext NSS high BW if not
 supported
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Cc:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Date:   Thu, 28 May 2020 19:53:26 +0200
In-Reply-To: <d8fe8e99def9c17099e98e3d467b259ee4229fcf.camel@sipsolutions.net> (sfid-20200528_195031_055874_F73843A6)
References: <20200528165011.993f108e96ca.I0086ae42d672379380d04ac5effb2f3d5135731b@changeid>
         <20200528165011.0e55d40c3ccc.I6fd0b4708ebd087e5e46466c3e91f6efbcbef668@changeid>
         (sfid-20200528_165447_100324_6B699F5D) <d8fe8e99def9c17099e98e3d467b259ee4229fcf.camel@sipsolutions.net>
         (sfid-20200528_195031_055874_F73843A6)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2020-05-28 at 19:50 +0200, Johannes Berg wrote:
> > If the AP advertises inconsistent data, namely it has CCFS1 or CCFS2,
> > but doesn't advertise support for 160/80+80 bandwidth or "Extended NSS
> > BW Support", then we cannot use any MCSes in the the higher bandwidth.
> > Thus, avoid connecting with higher bandwidth since it's less efficient
> > that way.
> 
> So ... this broke the tests :)
> 
> But really the code here seems consistent. What was in the tests is that
> the AP doesn't actually advertise 160 or 80+80 capability, so need to
> fix it like this:
> 


[...]

https://patchwork.ozlabs.org/project/hostap/patch/1590688350-I27cd72490492ff2c76f3689c882cf6f399e8ac9a@changeid/

johannes

