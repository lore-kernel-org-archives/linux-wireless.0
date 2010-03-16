Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:60331 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab0CPSms (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Mar 2010 14:42:48 -0400
Message-ID: <4B9FD11E.5050108@gmail.com>
Date: Tue, 16 Mar 2010 19:42:38 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: regd: sleeping in atomic
References: <4B9F86E9.2030702@gmail.com> <43e72e891003160918x3b7e3c9asf4fc8a9db35ccd8a@mail.gmail.com>
In-Reply-To: <43e72e891003160918x3b7e3c9asf4fc8a9db35ccd8a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/16/2010 05:18 PM, Luis R. Rodriguez wrote:
> one iteration of call_crda() which happens during module
> initialization and from what I gather I don't think the kernel is
> happy when you mutex_lock on load routines, please correct my foggy
> memory if I am mistaken.

No, using mutex in init/exit module routines is fine. Where do you have 
the information from? There might be problems only with request_module, 
flush_scheduled_work or similar.
