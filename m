Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:55876 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbYF3L31 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 07:29:27 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1159215waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2008 04:29:26 -0700 (PDT)
Message-ID: <1ba2fa240806300429l679f1568k584143b448455594@mail.gmail.com> (sfid-20080630_132930_015153_3D838E92)
Date: Mon, 30 Jun 2008 14:29:26 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: compat-wireless high packet loss.
Cc: "Guy Cohen" <guy.cohen@intel.com>,
	"David Miller" <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
	"Patrick McHardy" <kaber@trash.net>
In-Reply-To: <1214824149.5507.36.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1ba2fa240806261603g30c3e757y9166c2f9e05f7666@mail.gmail.com>
	 <247d6d340806282323v3192ead8v149359e482375991@mail.gmail.com>
	 <1214824149.5507.36.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 30, 2008 at 2:09 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2008-06-29 at 09:23 +0300, Guy Cohen wrote:
>> More info on the issue.. The problem is with TX of unrestrained UDP
>> stream, when the traffic generated at the application layer is larger
>> than the link can pass. With kernel 2.6.26-* the traffic is restrained
>> when the TX FIFOs gets full while in 2.6.25.* frames are dropped at
>> some layer. It seems that the drop happens after the IP fragmentation
>> step at the stack.
>
> does compat use multiqueue now? if not, look in the mac80211 fake mq
> code.

2.6.25 has a real mq
Thanks
Tomas
