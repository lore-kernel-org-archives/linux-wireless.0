Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:49725 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754004AbdKBRKX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Nov 2017 13:10:23 -0400
Received: by mail-io0-f196.google.com with SMTP id n137so519875iod.6
        for <linux-wireless@vger.kernel.org>; Thu, 02 Nov 2017 10:10:22 -0700 (PDT)
Date: Thu, 2 Nov 2017 10:10:18 -0700
From: Brian Norris <briannorris@chromium.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Ryan Hsu <ryanhsu@qti.qualcomm.com>,
        Govind Singh <govinds@qti.qualcomm.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
        Ben Greear <greearb@candelatech.com>,
        Colin Ian King <colin.king@canonical.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath10k: move pci suspend/resume functions
Message-ID: <20171102171017.GA11081@google.com> (sfid-20171102_181104_904451_95AB0992)
References: <20171102110903.2886660-1-arnd@arndb.de>
 <87mv44ln5v.fsf@qca.qualcomm.com>
 <CAK8P3a2xkh19gocctXf4gv1Km_SaYJPbSC5QkkZ0WMQQAXp83Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAK8P3a2xkh19gocctXf4gv1Km_SaYJPbSC5QkkZ0WMQQAXp83Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 02, 2017 at 04:40:57PM +0100, Arnd Bergmann wrote:
> On Thu, Nov 2, 2017 at 4:23 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> > Brian has already fixed this, please check that:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=ath-next&id=20665a9076d48e9abd9a2db13d307f58f7ef6647
> >
> > But apparently I forgot to merge ath-next to wireless-drivers-next, will
> > do that soon.
> 
> Yes, Brian's version is better. I considered the same, but wasn't sure
> it was safe.

Yes, it's safe. The code is still basically dead, since the mac80211 ops
get dropped with !CONFIG_PM (so no one calls the
*_hif_{suspend,resume}() functions), but at least we have fewer
#ifdef's.

Brian
