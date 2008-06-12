Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:57539 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbYFLGmh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 02:42:37 -0400
Received: by ug-out-1314.google.com with SMTP id h2so269817ugf.16
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 23:42:35 -0700 (PDT)
Message-ID: <f6ca9fed0806112342u1695182brfb99d53de67a77a2@mail.gmail.com> (sfid-20080612_084312_539857_36CD5A25)
Date: Thu, 12 Jun 2008 08:42:35 +0200
From: drago01 <drago01@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: [ipw3945-devel] [BUG] iwlwifi 3945 works only with disable_hw_scan=1
Cc: "Maxim Levitsky" <maximlevitsky@gmail.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1213237561.7814.688.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <484FF375.8010002@gmail.com>
	 <1213237561.7814.688.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 12, 2008 at 4:26 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> On Wed, 2008-06-11 at 18:47 +0300, Maxim Levitsky wrote:
>>
>> I found why I can't reenable wireless with wireless button.
>>
>> It turns out that iwlwifi doesn't enable the wireless function after a
>> R/F kill switch was enabled ether by the button or explicitly.
>>
>> I bisected this to commit 5a66926aa9230810704fd5a127966215fd58881e
>> in linus tree.
>
> The card will receive an interrupt when you disable the rf kill switch
> anyway [...]
It does? I thought thats only true for 4965 ... 3945 uses an ucode
event for that thats why it does not detect the rfkill state when the
interface is down.
