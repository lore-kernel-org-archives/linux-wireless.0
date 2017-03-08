Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0123.hostedemail.com ([216.40.44.123]:44523 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753877AbdCHSCY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 13:02:24 -0500
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave01.hostedemail.com (Postfix) with ESMTP id 312FB5E64B
        for <linux-wireless@vger.kernel.org>; Wed,  8 Mar 2017 17:54:30 +0000 (UTC)
Message-ID: <1488995605.2210.36.camel@perches.com> (sfid-20170308_190254_929452_CD4624B1)
Subject: Re: [PATCH v3] brcmfmac: Do not print the firmware version as an
 error
From: Joe Perches <joe@perches.com>
To: Hans de Goede <hdegoede@redhat.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Date: Wed, 08 Mar 2017 09:53:25 -0800
In-Reply-To: <797bce36-7887-24cb-2389-9a9e3c0d9760@redhat.com>
References: <20170308082321.4755-1-hdegoede@redhat.com>
         <1488990890.2210.33.camel@perches.com>
         <797bce36-7887-24cb-2389-9a9e3c0d9760@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-03-08 at 17:57 +0100, Hans de Goede wrote:
> Hi,

And hello back to you.

> On 08-03-17 17:34, Joe Perches wrote:
> > On Wed, 2017-03-08 at 09:23 +0100, Hans de Goede wrote:
> > > Using pr_err for things which are not errors is a bad idea. E.g. it
> > > will cause the plymouth bootsplash screen to drop back to the text
> > > console so that the user can see the error, which is not what we
> > > normally want to happen.
> > > 
> > > Instead add a new brcmf_info macro and use that.
> > > 
> > > Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> > > ---
> > > Changes in v2:
> > > -Fix brcm_err typo (should be brcmf_err) in CONFIG_BRCM_TRACING case
> > > Changes in v3:
> > > -Use do { } while (0) around macro
> > 
> > why?  Single statement macros do not need a do/while
> 
> Because Arend ask me to during review of v2.

Well, maybe Arend should learn that single statement macros
don't need do/while guards and that do/while guards are
generally not used in the kernel for single statements.
