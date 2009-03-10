Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from queueout03-winn.ispmail.ntl.com ([81.103.221.33]:57798 "EHLO
	queueout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752268AbZCJNf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 09:35:56 -0400
Message-ID: <49B66A73.4030408@gentoo.org> (sfid-20090310_143600_934576_E7B266ED)
Date: Tue, 10 Mar 2009 09:26:11 -0400
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC] zd1211rw: remove zd_addr_t typedef for a simple u16
References: <1236651030-10331-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1236651030-10331-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> The __nocast attribute is used to shut sparse up but we
> don't need it, lets just use u16 directly.

Which warning does this remove?

The purpose of this system was (I think) to make it so that if you got 
addr and value in the wrong order in calls to e.g. zd_ioread16() then 
sparse would tell you about it. Looks like your patch would remove that 
protection?

Admittedly it is a bit of a strange thing and no excuse for programmers 
getting parameters in the wrong order.. if it needs to go then I'm happy 
with whatever you decide.

Daniel
