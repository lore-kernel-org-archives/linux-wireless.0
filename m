Return-Path: <SRS0=bBvh=4H=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB1D1C34047
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Feb 2020 09:13:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E8B024672
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Feb 2020 09:13:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgBSJNr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Feb 2020 04:13:47 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:48842 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgBSJNr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Feb 2020 04:13:47 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j4LQK-008lC9-EI; Wed, 19 Feb 2020 10:13:40 +0100
Message-ID: <ff8a005c68e512cb3f338b7381853e6b3a3ab293.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: Pass lockdep expression to RCU lists
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Amol Grover <frextrite@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Date:   Wed, 19 Feb 2020 10:13:36 +0100
In-Reply-To: <20200219091102.10709-1-frextrite@gmail.com> (sfid-20200219_101235_133080_876B0E75)
References: <20200219091102.10709-1-frextrite@gmail.com>
         (sfid-20200219_101235_133080_876B0E75)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2020-02-19 at 14:41 +0530, Amol Grover wrote:
>  
> -	WARN_ON_ONCE(!rcu_read_lock_held() && !lockdep_rtnl_is_held());
> -
> -	list_for_each_entry_rcu(pos, &rdev->sched_scan_req_list, list) {
> +	list_for_each_entry_rcu(pos, &rdev->sched_scan_req_list, list,
> +				lockdep_rtnl_is_held()) {

Huh, I didn't even know you _could_ do that :)

johannes

