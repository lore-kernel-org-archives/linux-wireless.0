Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C49BC433EF
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Mar 2022 19:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiCQUAP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Mar 2022 16:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiCQUAM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Mar 2022 16:00:12 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5D8F7F79;
        Thu, 17 Mar 2022 12:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=+8okQr4MHQH3zBSNUjLKivj6mKt9YG/HoolYiG+2r5A=;
        t=1647547131; x=1648756731; b=Oq4P7qqRtVLqc+t+0agwe+bdjj2FGLMCtZyw0RyQl5OvpFG
        VJMklD8mbQvetfBYya+4Szph3N+OpRE2q2HK9hLlD2LznZl/Tzm6oP6ofO+mQNZekVKnRbzdFRQrU
        ZlYHFnk84NewB8vcAEv9jLmquP/EdE4evlAweqBhlHXLoRmj90f0dHtGba4GjXo16LU4P4fhTL5Pp
        MilHAQKiqgxmrtITx+Lk5z6HbgzaY31OhCBWzX+uzvacGQJ1xs8WfL50nhy0rU7UZl9VyPqRAhHCp
        k3SnFnKn6a5Q3VBLTjZB4Hi3Y+4pef2lhOT5xQ3P+ThM2NZem3mVzxQ11E4LC+DQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nUwGl-00EZKe-6Z;
        Thu, 17 Mar 2022 20:58:47 +0100
Message-ID: <af8ea77765cc30ff448256c278b69b2402f018f6.camel@sipsolutions.net>
Subject: Re: net-next: regression: patch "iwlwifi: acpi: move ppag code from
 mvm to fw/acpi" (e8e10a37c51c) breaks wifi
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Matt Chen <matt.chen@intel.com>
Cc:     netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org
Date:   Thu, 17 Mar 2022 20:58:46 +0100
In-Reply-To: <18e04a04-2aed-13de-b2fc-dbf5df864359@hartkopp.net>
References: <18e04a04-2aed-13de-b2fc-dbf5df864359@hartkopp.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2022-03-17 at 20:56 +0100, Oliver Hartkopp wrote:
> Hi all,
> 
> the patch "iwlwifi: acpi: move ppag code from mvm to fw/acpi" (net-next 
> commit e8e10a37c51c) breaks the wifi on my HP Elitebook 840 G5.
> 
> I detected the problem when working on the latest net-next tree and the 
> wifi was fine until this patch.
> 

Something like this should get submitted soon:
https://p.sipsolutions.net/3b84353278ed68c6.txt

johannes
