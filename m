Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	FREEMAIL_REPLYTO_END_DIGIT,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98062C282C2
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 13:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 333EA20844
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 13:21:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.ch header.i=@protonmail.ch header.b="al70W5Lm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730695AbfBFNVD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 08:21:03 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:45722 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730621AbfBFNVC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 08:21:02 -0500
Date:   Wed, 06 Feb 2019 13:20:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=default; t=1549459259;
        bh=wMol4HWtSsDz5lH9Pz2NnmQTFlg29IpaT3YpnLElIRA=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=al70W5LmiFsD6rBiowruiumgwxYX8dYji4PhfS6FVp2TUdMhxhllDAh0pcm/4BCKv
         nhYm8x2xZVbKKLtQVl7VHY7BnpMYpcvXsCYDcBq1GR8at8h22kUgQa4rKQvucrtRLc
         4M9CwgZBpdz337eOyHprrDYq2AqFRKASFZbPHagw=
To:     Luca Coelho <luca@coelho.fi>
From:   Jordan Glover <Golden_Miller83@protonmail.ch>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linuxwifi@intel.com" <linuxwifi@intel.com>
Reply-To: Jordan Glover <Golden_Miller83@protonmail.ch>
Subject: Re: [BUG] Microcode SW error detected
Message-ID: <NR7zW4fbUVRT2M-BPgYpYxw3vAnf4ljS4lveqH_pNztV_jTFnS85yO3kRbEcLzB8rZhwq797ENsyVXJoWARQ3ydzhPF9yMyTqivEBfXIwUU=@protonmail.ch>
In-Reply-To: <1592d4db90b6cee8bc794bcbce06a14fd5226b16.camel@coelho.fi>
References: <CsFdFFRzbpRX_m4C5xfEsE9P5-uv6mNwOUyPl734lLQreQIV9__vxr1NWPkf5oltyFjTZ--34SLql_9ywXamnmw1B7K8lWFzU9kwzWJTdRI=@protonmail.ch>
 <1592d4db90b6cee8bc794bcbce06a14fd5226b16.camel@coelho.fi>
Feedback-ID: QEdvdaLhFJaqnofhWA-dldGwsuoeDdDw7vz0UPs8r8sanA3bIt8zJdf4aDqYKSy4gJuZ0WvFYJtvq21y6ge_uQ==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wednesday, February 6, 2019 7:08 AM, Luca Coelho <luca@coelho.fi> wrote:
>
> This seems to be related to this bugzilla:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=3D202397
>
> Can you please comment on that report stating that you are experiencing
> the same (or something similar)?
>
> Thanks!
>
>
> Cheers,
> Luca.

Thank you for the reply.

It may be similar problem but I'm not getting
"NULL pointer dereference error" as described in linked issue.

I already created separate bug report at:
https://bugzilla.kernel.org/show_bug.cgi?id=3D202513

I think this issue may be caused by firmware update for intel 8000
series which could be buggy itself or just uncovered bugs in iwlwifi
driver:
https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git=
/commit/?id=3D8707ef3313ee0f6737683c93aa2cb1dff6483643

Downgrading linux-firmware package to version before that commit seems
to make this issue go away.

Jordan
