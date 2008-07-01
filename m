Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:57545 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384AbYGAJ3R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 05:29:17 -0400
Received: by an-out-0708.google.com with SMTP id d40so382092and.103
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jul 2008 02:29:16 -0700 (PDT)
Message-ID: <43e72e890807010229m12b7382ft8675924cac923c7b@mail.gmail.com> (sfid-20080701_112938_014662_BF5C7419)
Date: Tue, 1 Jul 2008 02:29:16 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: compat-wireless high packet loss.
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Guy Cohen" <guy.cohen@intel.com>,
	"David Miller" <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
	"Patrick McHardy" <kaber@trash.net>
In-Reply-To: <1ba2fa240806300429l679f1568k584143b448455594@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1ba2fa240806261603g30c3e757y9166c2f9e05f7666@mail.gmail.com>
	 <247d6d340806282323v3192ead8v149359e482375991@mail.gmail.com>
	 <1214824149.5507.36.camel@johannes.berg>
	 <1ba2fa240806300429l679f1568k584143b448455594@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 30, 2008 at 4:29 AM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Mon, Jun 30, 2008 at 2:09 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Sun, 2008-06-29 at 09:23 +0300, Guy Cohen wrote:
>>> More info on the issue.. The problem is with TX of unrestrained UDP
>>> stream, when the traffic generated at the application layer is larger
>>> than the link can pass. With kernel 2.6.26-* the traffic is restrained
>>> when the TX FIFOs gets full while in 2.6.25.* frames are dropped at
>>> some layer. It seems that the drop happens after the IP fragmentation
>>> step at the stack.
>>
>> does compat use multiqueue now? if not, look in the mac80211 fake mq
>> code.
>
> 2.6.25 has a real mq

We only use fake mq support for kernels <= 2.6.22 as 2.6.23 added
support for MQ. Also if your 2.6.23 doesn't have MQ it will warn you.

  Luis
