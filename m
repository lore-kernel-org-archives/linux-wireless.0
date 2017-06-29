Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0042.outbound.protection.outlook.com ([104.47.42.42]:63764
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751690AbdF2QtR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 12:49:17 -0400
Date: Thu, 29 Jun 2017 19:49:04 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: Re: [PATCH 8/8] qtnfmac: implement scan timeout
Message-ID: <20170629164903.adst7rihexlrb643@bars> (sfid-20170629_184922_258889_54516305)
References: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
 <20170620195517.18373-9-sergey.matyukevich.os@quantenna.com>
 <87o9t949yu.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87o9t949yu.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 27, 2017 at 08:27:37PM +0300, Kalle Valo wrote:
> 
> External Email
> 
> 
> Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:
> 
> > Userspace tools may hang on scan in the case when scan completion event
> > is not returned by firmware. This patch implements the scan timeout
> > to avoid such situation.
> >
> > Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
> 
> [...]
> 
> > +static __always_inline void qtnf_wmac_lock(struct qtnf_wmac *mac)
> > +{
> > +     mutex_lock(&mac->mac_lock);
> > +}
> > +
> > +static __always_inline void qtnf_wmac_unlock(struct qtnf_wmac *mac)
> > +{
> > +     mutex_unlock(&mac->mac_lock);
> > +}
> 
> Why? These look pointless to me.

Could you please clarify a bit. You mean, locking/unlocking directly instead of
using inline wrappers ?
