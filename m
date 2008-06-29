Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:45440 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYF2GXt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2008 02:23:49 -0400
Received: by fg-out-1718.google.com with SMTP id 19so538731fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2008 23:23:36 -0700 (PDT)
Message-ID: <247d6d340806282323v3192ead8v149359e482375991@mail.gmail.com> (sfid-20080629_082355_009658_4E662435)
Date: Sun, 29 Jun 2008 09:23:32 +0300
From: "Guy Cohen" <guy.cohen@intel.com>
To: "Tomas Winkler" <tomasw@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"David Miller" <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
	"Patrick McHardy" <kaber@trash.net>
Subject: Re: compat-wireless high packet loss.
In-Reply-To: <1ba2fa240806261603g30c3e757y9166c2f9e05f7666@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1ba2fa240806261603g30c3e757y9166c2f9e05f7666@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

More info on the issue.. The problem is with TX of unrestrained UDP
stream, when the traffic generated at the application layer is larger
than the link can pass. With kernel 2.6.26-* the traffic is restrained
when the TX FIFOs gets full while in 2.6.25.* frames are dropped at
some layer. It seems that the drop happens after the IP fragmentation
step at the stack.

Thanks,
Guy.

On 6/27/08, Tomas Winkler <tomasw@gmail.com> wrote:
> We've experienced very high packet loss when using latest
> compat-wireless witth iwlwifi driver over 2.6.24 and 2.6.25 stable
> kernels. This is not happening with 2.6.26-rc3 as a target kernel (not
> sure about rc1 and rc2)
> The traffic is UDP TX with large tx buffers ~26000.
> We are still investigating yet if someone has any idea please share with us.
> Thanks
> Tomas
