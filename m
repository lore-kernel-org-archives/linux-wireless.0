Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44639 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab3JINkn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Oct 2013 09:40:43 -0400
Received: by mail-lb0-f174.google.com with SMTP id w6so775447lbh.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Oct 2013 06:40:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131009132429.GA1265@redhat.com>
References: <20131009132429.GA1265@redhat.com>
Date: Wed, 9 Oct 2013 16:40:41 +0300
Message-ID: <CANUX_P1_nOFS8EY05vu3A+1G5gG5eamWMAu-Pd=X=bvTowSj2Q@mail.gmail.com> (sfid-20131009_154046_906553_4295B75B)
Subject: Re: [PATCH] iwlwifi: don't WARN on bad firmware state
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 9, 2013 at 4:24 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> When we restart firmware and it is marked as not alive, we can still get
> calls from mac80211. Don't WARN on in this situation as this triggers
> automatic bug reports with no valuable information.
>
> This continuation of:
>
> commit 8ca95995e64f5d270889badb3e449dca91106a2b
> Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Date:   Sun Sep 15 11:37:17 2013 +0300
>
>     iwlwifi: don't WARN on host commands sent when firmware is dead
>
> which remove WARN_ONCE from one place, but those warnings are also
> triggered from other functions.
>
> Patch also adds unlikely() statement.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

I picked it up. Thanks.
