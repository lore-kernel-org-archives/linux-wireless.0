Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34557 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089AbbDUQly (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2015 12:41:54 -0400
Date: Tue, 21 Apr 2015 18:41:51 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	keescook@chromium.org, casey@schaufler-ca.com,
	cocci@systeme.lip6.fr, Jani Nikula <jani.nikula@intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Hannes Reinecke <hare@suse.de>, Tejun Heo <tj@kernel.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v1 4/6] moduleparam.h: add module_param_config_*() helpers
Message-ID: <20150421164151.GK5622@wotan.suse.de> (sfid-20150421_184217_564692_E18CA51E)
References: <1429572637-30234-1-git-send-email-mcgrof@do-not-panic.com>
 <1429572637-30234-5-git-send-email-mcgrof@do-not-panic.com>
 <CAGRGNgVZyFQgmb9kLq1-rvJQwr5NnBHCEMqgn3CNmD5ki6w=ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGRGNgVZyFQgmb9kLq1-rvJQwr5NnBHCEMqgn3CNmD5ki6w=ng@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 21, 2015 at 09:42:21AM +1000, Julian Calaby wrote:
> Hi Luis,
> 
> You made a spelling mistake:
> 
> On Tue, Apr 21, 2015 at 9:30 AM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> >
> > This adds a couple of bool module_param_config_*() helpers
> > which are designed to let us easily associate a booloean
> > module parameter with an associated kernel configuration
> > option, and to help us remove #ifdef'ery eyesores.
> >
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > Cc: Jani Nikula <jani.nikula@intel.com>
> > Cc: Christoph Hellwig <hch@infradead.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: linux-kernel@vger.kernel.org
> > Cc: cocci@systeme.lip6.fr
> > Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> > ---
> >  include/linux/moduleparam.h | 37 +++++++++++++++++++++++++++++++++++++
> >  1 file changed, 37 insertions(+)
> >
> > diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> > index 7e00799..fdf7b87 100644
> > --- a/include/linux/moduleparam.h
> > +++ b/include/linux/moduleparam.h
> > @@ -155,6 +155,43 @@ struct kparam_array
> >         __MODULE_PARM_TYPE(name, #type)
> >
> >  /**
> > + * module_param_config_on_off - bool parameter with run time override
> > + * @name: a valid C identifier which is the parameter name.
> > + * @value: the actual lvalue to alter.
> > + * @perm: visibility in sysfs.
> > + * @config: kernel parameter which will enable this option if this
> > + *     kernel configuration option has been enabled.
> > + *
> > + * This lets you define a bool module paramter which by default will be
> 
> s/paramter/parameter/
> 
> > + * set to true if the config option has been set on your kernel's
> > + * configuration, otherwise it is set to false.
> > + */
> > +#define module_param_config_on_off(name, var, perm, config)            \
> > +       static bool var = IS_ENABLED(config);                           \
> > +       module_param_named(name, var, bool, perm);
> > +
> > +/**
> > + * module_param_config_on - bool parameter with run time enablement override
> > + * @name: a valid C identifier which is the parameter name.
> > + * @value: the actual lvalue to alter.
> > + * @perm: visibility in sysfs.
> > + * @config: kernel parameter which will enable this option if this
> > + *     kernel configuration option has been enabled.
> > + *
> > + * This lets you define a bool module paramter which by default will be
> 
> Here too.

Fixed, thanks.

  Luis
