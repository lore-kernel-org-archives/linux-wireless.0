Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35312 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754722AbdD0Apr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 20:45:47 -0400
Date: Thu, 27 Apr 2017 02:45:45 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: brcmfmac: don't warn user if requested nvram fails
Message-ID: <20170427004545.GE28800@wotan.suse.de> (sfid-20170427_024622_335658_1B06DE39)
References: <09063fc2-af77-ced6-ed90-ab20e2884969@redhat.com>
 <577dc508-07ff-c74f-5c90-b6baf4e7694a@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <577dc508-07ff-c74f-5c90-b6baf4e7694a@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 07, 2017 at 11:43:04PM +0200, Arend Van Spriel wrote:
> On 6-4-2017 14:14, Hans de Goede wrote:
> > Luis, do you think it would be a good idea to add
> > .optional_postfix member to driver_data_req_params
> > for this? I believe other sdio based wifi devices
> > may want to do the same, or should this be handled
> > in the driver by doing 2 driver_data_request_async
> > calls (the 2nd when the 1st fails) ?
> 
> I think we briefly touched this subject a while ago. It would be great
> if the driver_data api could be given a list/array of files which can be
> flagged as required or optional. Just not sure how to deal with drivers
> that request a firmware file and fallback to requesting older ones
> repeatedly thus stop processing upon first successful load. Both
> use-cases seem present in drivers.

I've now added chaining request support and it follows the API model
devised by Intel, as it is very sensible and should also work with open
firmware models very well. By default the optional nature is specific to
anything in between, but it will complain if no file is found at all,
unless of course the entire set is optional.

If the series of files do not match a simple API model / revisions,
then yes, I'd be happy to support allowing users to specify a list
of files with their own set of specific requirements (including specifying
if one optional or not). How I'd advise for this to be supported would be
with a flexible array pointer and setting the pointer / num_members later,
for processing. I recently had to demo how to do this so here is a simple
demo using flexible arrays embedded:

http://drvbp1.linux-foundation.org/~mcgrof/demos/demo-flexible-array-subopts.c

I would imagine macros can be added to driver_data.h to make spelling out
file entries easier to read.

Everything must be const on the request though. Oh and we want respective
test cases in the new test driver to ensure we never regress and things
work just as expected.

I'll respin the driver data API once again now addressing hopefully
the last pieces of feedback.

  Luis
