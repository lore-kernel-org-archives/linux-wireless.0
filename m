Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30DFEC4332F
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Mar 2022 17:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239581AbiCRRW2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Mar 2022 13:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239567AbiCRRW2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Mar 2022 13:22:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614382E7111;
        Fri, 18 Mar 2022 10:21:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08E9AB824D1;
        Fri, 18 Mar 2022 17:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845C0C340EC;
        Fri, 18 Mar 2022 17:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647624066;
        bh=YnaXBXIzaudyrcSZNNHHyZOTUTHVxgsoLNKcosQWjW4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k4wQ4UkZv+9wyM+M7GP/A1FVL6eKF2RHBZNAo8pcJiqI0CUpd4d8yj50M1/XQ1mwH
         Ny2mOV1UDdHFKjWiFbETNhFxRsXyiP9zXvOcLw3+IIIK/xMBhw4eJJ3Lj9rBeX/TF/
         /Y46gJ66BlB46AEOqr+Bo0PBHa4bZS9QRF47+ErSHVbqyYcnWZEljxzkgv7WzT20Xv
         IAao9GQ3ORvxDYC/ITS6GIVkXUybeD0zdAp5rEwU6CGwSpGdxQo62HGmYsZsmcTk9v
         dH3Axi+jakMys5JMzMfH7LYB/Iad3r2HfJQTKnXIXXRkZPvyamyuZ7jfImuw2lnYrn
         DAiCgU1k2eGPg==
Date:   Fri, 18 Mar 2022 10:21:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Matt Chen <matt.chen@intel.com>,
        netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: net-next: regression: patch "iwlwifi: acpi: move ppag code from
 mvm to fw/acpi" (e8e10a37c51c) breaks wifi
Message-ID: <20220318102100.7dfeeced@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <af8ea77765cc30ff448256c278b69b2402f018f6.camel@sipsolutions.net>
References: <18e04a04-2aed-13de-b2fc-dbf5df864359@hartkopp.net>
        <af8ea77765cc30ff448256c278b69b2402f018f6.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 17 Mar 2022 20:58:46 +0100 Johannes Berg wrote:
> On Thu, 2022-03-17 at 20:56 +0100, Oliver Hartkopp wrote:
> > Hi all,
> > 
> > the patch "iwlwifi: acpi: move ppag code from mvm to fw/acpi" (net-next 
> > commit e8e10a37c51c) breaks the wifi on my HP Elitebook 840 G5.
> > 
> > I detected the problem when working on the latest net-next tree and the 
> > wifi was fine until this patch.
> >   
> 
> Something like this should get submitted soon:
> https://p.sipsolutions.net/3b84353278ed68c6.txt

Hi Johannes, we're readying up for the merge window, feels like this
may be something we want fixed before we ship net-next off to Linus.
Do you have an ETA on the fix? Am I overestimating the importance?
