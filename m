Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:47720 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571Ab2EGRG6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 13:06:58 -0400
Message-ID: <1336410360.5970.103.camel@aeonflux> (sfid-20120507_190703_226682_BDCAB7FE)
Subject: Re: [PATCH] Bluetooth: Fix coding style
From: Marcel Holtmann <marcel@holtmann.org>
To: David Miller <davem@davemloft.net>
Cc: dh.herrmann@googlemail.com, gustavo@padovan.org,
	linville@tuxdriver.com, linux-bluetooth@vger.kernel.org,
	linux-wireless@vger.kernel.org
Date: Mon, 07 May 2012 10:06:00 -0700
In-Reply-To: <20120506.145304.1998242927519675381.davem@davemloft.net>
References: <1336157988-4602-1-git-send-email-gustavo@padovan.org>
	 <20120506.123656.1335354317428258137.davem@davemloft.net>
	 <CANq1E4TTfDxZPsOqqWUT7PqTKUr8nCTC-wo=iGe_pxoUmnecgQ@mail.gmail.com>
	 <20120506.145304.1998242927519675381.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

> > Whose rules are they?
> 
> Find me an example in another major core subsystem, let's use
> mm/memory.c as an example as that file gets hit by a lot of people,
> that uses the multi-line conditional TAB-only crap you guys seem to
> keep using.
> 
> They don't.  All the examples you'll find are of the form:
> 
> 	if (a &&
> 	    b)
> 
> not:
> 
> 	if (a &&
> 			b)

except of course in zap_vma_ptes(), remap_pmd_range(), remap_pud_range()
and do_wp_page().

So we also have this one:

		if ((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
				     (VM_WRITE|VM_SHARED))
			goto reuse;

And this:

	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
					(VM_WRITE|VM_SHARED))) {

What kind of style requirement is that one?

			tmp = vma->vm_ops->page_mkwrite(vma, &vmf);
			if (unlikely(tmp &
					(VM_FAULT_ERROR | VM_FAULT_NOPAGE))) {
				ret = tmp;
				goto unwritable_page;
			}

Have you actually looked at mm/memory.c and confirmed that it is a good
example of multi-line indentation?

When it comes to function declaration and function calls, the style in
mm/memory.c is mixed. We can start counting, but for both other
multi-line cases it seems that tab-only indentation is predominant.

Regards

Marcel


