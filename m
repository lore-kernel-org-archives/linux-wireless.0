Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5288DC05027
	for <linux-wireless@archiver.kernel.org>; Wed,  8 Feb 2023 20:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbjBHUSD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 8 Feb 2023 15:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbjBHUSC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2023 15:18:02 -0500
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122253251B
        for <linux-wireless@vger.kernel.org>; Wed,  8 Feb 2023 12:18:00 -0800 (PST)
Received: (wp-smtpd smtp.wp.pl 1855 invoked from network); 8 Feb 2023 21:17:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1675887478; bh=PtURNfYEoKITRRbyvk3vAQH6aL3o5R7Jm4zlISWUBUM=;
          h=From:To:Cc:Subject;
          b=fqUDeB8a1xUM0pXzczkN9tCMadnMUY2uSXYk2R+avJsCdl+QST3+CMFb2jlmqPHwf
           nncJnnX0CMB+M1CqBfTQ3g60i/so/U4eo1AmvMhoZZ0GvUKwgPNWui5hSeSM29kRn4
           CKstOkGQosv44Ngaf1b1cVo9SMNlbelF97Yw3HYI=
Received: from 89-64-15-40.dynamic.chello.pl (HELO localhost) (stf_xl@wp.pl@[89.64.15.40])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <jiasheng@iscas.ac.cn>; 8 Feb 2023 21:17:58 +0100
Date:   Wed, 8 Feb 2023 21:17:57 +0100
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iwl3945: Add missing check for
 create_singlethread_workqueue
Message-ID: <20230208201757.GB1435569@wp.pl>
References: <20230208063032.42763-1-jiasheng@iscas.ac.cn>
 <20230208063032.42763-2-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208063032.42763-2-jiasheng@iscas.ac.cn>
X-WP-MailID: f397f3d1b287d936b978b5d9adf80467
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [obOV]                               
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Feb 08, 2023 at 02:30:32PM +0800, Jiasheng Jiang wrote:
> Add the check for the return value of the create_singlethread_workqueue
> in order to avoid NULL pointer dereference.
> 
> Fixes: b481de9ca074 ("[IWLWIFI]: add iwlwifi wireless drivers")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
