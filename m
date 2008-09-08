Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33241 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbYIHVPd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 17:15:33 -0400
Date: Mon, 8 Sep 2008 17:01:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org, cjb@laptop.org, stable@kernel.org
Subject: Re: [PATCH] libertas: clear current command on card removal
Message-ID: <20080908210110.GD24557@tuxdriver.com> (sfid-20080908_231536_766552_87CBB685)
References: <1220906080.1618.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1220906080.1618.20.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 08, 2008 at 04:34:40PM -0400, Dan Williams wrote:
> If certain commands were in-flight when the card was pulled or the
> driver rmmod-ed, cleanup would block on the work queue stopping, but the
> work queue was in turn blocked on the current command being canceled,
> which didn't happen.  Fix that.
> 
> Signed-off-by: Dan Williams <dcbw@redhat.com>
> ---
> John, this is 2.6.27 material if there's still time.

I have to remind you of the new "regressions only" policy.  Is this a
problem that we introduced in old code during the 2.6.27 merge window?

John
-- 
John W. Linville
linville@tuxdriver.com
