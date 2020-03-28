Return-Path: <SRS0=P4PU=5N=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A03EC43331
	for <linux-wireless@archiver.kernel.org>; Sat, 28 Mar 2020 11:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C56B20716
	for <linux-wireless@archiver.kernel.org>; Sat, 28 Mar 2020 11:02:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JD84yMJy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgC1LCy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 28 Mar 2020 07:02:54 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:38131 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbgC1LCy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Mar 2020 07:02:54 -0400
Received: by mail-vs1-f66.google.com with SMTP id x206so7894723vsx.5
        for <linux-wireless@vger.kernel.org>; Sat, 28 Mar 2020 04:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GnodiSBQXr+6/IIW8j5azeGDTXruvDyXlMQYrI3kxI4=;
        b=JD84yMJymY7XIMTngif1B8O4J7cbNxzy+KT3XHxttWVtZuvVkhUsWrg0pxB7nAF4NG
         g5+PSkpF3/aDJqV+7yr0tp8IqCK41p8znPpHETtX84j96cM4qUb/x3NZnwiRnH2qQq7c
         SENRY74evDmkoyAyGPZjEHJCE9GCOK6pmP+be1RoP4CsCrk7R7TB3twVAv0YNGZUYnmt
         SVyZgPm3r9LnUA76nXNPVxU9he+Ch5kt1WdGiNDmLahmWbD92VJspMXZ1PLVKhU/TKF3
         ruX9rkaAxfzSXs4wdDs7NMr6BLsY7TvOjb2XnQ2LTW44p9x1WHrCwxF9PayIsj/afsDy
         E1pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GnodiSBQXr+6/IIW8j5azeGDTXruvDyXlMQYrI3kxI4=;
        b=NAh+WDeud940S4nYxOrDuvuNHRJe6xm4bK4CZLy8o9mt4L35aUU8vNyP6/bXBNvNEO
         0c0mEe9roHX0YdyQxYG5NDBO7IzgUWniQeRj00eMGqjwcRa0Pj+1iFq4q/sPggZnXQd3
         3iccCqnAjhUupBmTQphvinIZq4ELue53ge+WLzhT1nrKevZHb7lLJJqkletSyDi1Axm3
         RRoNCWQcGFkKZEXMqAW02yYfbDbvHnEbrS+ULWGzqD1KkJHYDiVlwV0UCc0XbLrnTAlW
         QYP0zPR53BR97u58OcMlkZcsk3TDn+16iqvROIBn9zLu8n/o8QXw031qxaK2d/6NX0xM
         GMlA==
X-Gm-Message-State: AGi0PubkLtnsXeil6Jqq8JXHt0MBDIJjxJv5I3HRum7CmPFUUazZtG+d
        OmvTkk2PhsURESb2KMtyHcSJuXaw9g0Cll7rMBk=
X-Google-Smtp-Source: APiQypJWR3OoJcY3ZsiGLfhK2iZGYUsySqyVgrs4H16vnqICkNXz4paJS3sQQJ5QRA/wj7nfaMx9E4VAB+waHQ918Zo=
X-Received: by 2002:a67:4384:: with SMTP id q126mr2335549vsa.154.1585393371691;
 Sat, 28 Mar 2020 04:02:51 -0700 (PDT)
MIME-Version: 1.0
References: <iwlwifi.20200318081237.46db40617cc6.Id5cf852ec8c5dbf20ba86bad7b165a0c828f8b2e@changeid>
 <20200323163858.A1183C44788@smtp.codeaurora.org>
In-Reply-To: <20200323163858.A1183C44788@smtp.codeaurora.org>
From:   Felipe Contreras <felipe.contreras@gmail.com>
Date:   Sat, 28 Mar 2020 05:02:40 -0600
Message-ID: <CAMP44s0xmss2sOpJ7e-Vx-bq8mx+Q+pO3B-SDaaST_iEPOM_3g@mail.gmail.com>
Subject: Re: [PATCH v5.6] iwlwifi: don't send GEO_TX_POWER_LIMIT if no wgds table
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Luca Coelho <luca@coelho.fi>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, noodles@earth.li
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Mar 23, 2020 at 10:42 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Luca Coelho <luca@coelho.fi> wrote:
>
> > From: Golan Ben Ami <golan.ben.ami@intel.com>
> >
> > The GEO_TX_POWER_LIMIT command was sent although
> > there is no wgds table, so the fw got wrong SAR values
> > from the driver.
> >
> > Fix this by avoiding sending the command if no wgds
> > tables are available.
> >
> > Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
> > Fixes: 39c1a9728f93 ("iwlwifi: refactor the SAR tables from mvm to acpi")
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> > Tested-By: Jonathan McDowell <noodles@earth.li>
> > Tested-by: Len Brown <len.brown@intel.com>
>
> Patch applied to wireless-drivers.git, thanks.
>
> 0433ae556ec8 iwlwifi: don't send GEO_TX_POWER_LIMIT if no wgds table

This should be applied to the stable tree, shouldn't it? 5.5 stable
releases have this issue.

-- 
Felipe Contreras
