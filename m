Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:44721 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967069AbeEYQeF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 12:34:05 -0400
Received: from mail-io0-f200.google.com ([209.85.223.200])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1fMFfI-0005Ja-CU
        for linux-wireless@vger.kernel.org; Fri, 25 May 2018 16:34:04 +0000
Received: by mail-io0-f200.google.com with SMTP id k9-v6so4732967ioa.6
        for <linux-wireless@vger.kernel.org>; Fri, 25 May 2018 09:34:04 -0700 (PDT)
Date: Fri, 25 May 2018 11:34:01 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless-regdb: Fix comparison of WmmRule with NoneType
 in python 3
Message-ID: <20180525163401.GW3401@ubuntu-xps13> (sfid-20180525_183431_115838_A68EA4D7)
References: <20180518144701.25138-1-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180518144701.25138-1-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 18, 2018 at 09:47:01AM -0500, Seth Forshee wrote:
> Python 3 gives errors as a result of the changes to add wmm
> rules since Permission.wmmrule can be set to None:
> 
>  TypeError: '<' not supported between instances of 'WmmRule' and 'NoneType'
> 
> To fix this, supply compairson methods for WmmRule instead of
> using the ones provided by attrs. Doing this means we also need
> to supply a __hash__ method.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Applied.
