Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:42222 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934425AbcJVQiZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Oct 2016 12:38:25 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: sequence diagrams in rst documentation
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <1477084793.4068.63.camel@sipsolutions.net>
Date: Sat, 22 Oct 2016 18:37:42 +0200
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        linux-wireless@vger.kernel.org,
        linux-doc <linux-doc@vger.kernel.org>
Message-Id: <A533ED1D-9F0F-420D-9835-723F33D6CA83@darmarit.de> (sfid-20161022_183835_136912_B8ED5A79)
References: <1476190613-2403-1-git-send-email-johannes@sipsolutions.net> <20161011072119.7ad4e3a3@lwn.net> <1476193466.4118.10.camel@sipsolutions.net> <1476194038.4118.11.camel@sipsolutions.net> <1476791021.6425.25.camel@sipsolutions.net> <20161018175236.75c8c4e2@lwn.net> <1476863488.5927.10.camel@sipsolutions.net> <1477053099.4068.42.camel@sipsolutions.net> <87k2d1q2qx.fsf@intel.com> <1477055055.4068.46.camel@sipsolutions.net> <EFAA684D-941C-45F9-8D37-F28EF3B11F4F@darmarit.de> <1477084793.4068.63.camel@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Am 21.10.2016 um 23:19 schrieb Johannes Berg <johannes@sipsolutions.net>:

> On Fri, 2016-10-21 at 18:11 +0200, Markus Heiser wrote:
> 
>> Yes and No. It depends on the tools (toolchains) we want to use.
>> As far as I can see from a abstract POV it should by simple for
>> math:: / since we already use/need LaTeX for PDF, for other tools
>> I have to look.
> 
> Not sure if we were talking past each other - but the pass-through is
> actually really simple - example patch below.

Yeah, I thought something similar. But is the import of the extension
a sufficient criteria? 

About ".. math::"; I guess we have to check if math extension AND
pdflatex is installed.

What do you suppose?

(ATM my comments on this are superficial, sorry that I haven't not
yet fond the time, to look closer into all these generators).

--Markus--


 
> 
> This makes it output an SVG (with fallback to PNG even) into the HTML,
> a PDF into the PDF, and plain pre-formatted text for both when the
> plantuml sphinx plugin isn't installed.
> 
> johannes
> 
> 
> diff --git a/Documentation/conf.py b/Documentation/conf.py
> index bf6f310e5170..2c00ab6f0baf 100644
> --- a/Documentation/conf.py
> +++ b/Documentation/conf.py
> @@ -34,7 +34,8 @@ from load_config import loadConfig
> # Add any Sphinx extension module names here, as strings. They can be
> # extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
> # ones.
> -extensions = ['kernel-doc', 'rstFlatTable', 'kernel_include', 'cdomain']
> +extensions = ['kernel-doc', 'rstFlatTable', 'kernel_include', 'cdomain',
> +              'plantuml']
> 
> # The name of the math extension changed on Sphinx 1.4
> if minor > 3:
> @@ -494,6 +495,9 @@ pdf_documents = [
> kerneldoc_bin = '../scripts/kernel-doc'
> kerneldoc_srctree = '..'
> 
> +plantuml_output_format = "svg"
> +plantuml_latex_output_format = "pdf"
> +
> # ------------------------------------------------------------------------------
> # Since loadConfig overwrites settings from the global namespace, it has to be
> # the last statement in the conf.py file
> diff --git a/Documentation/driver-api/index.rst b/Documentation/driver-api/index.rst
> index 8e259c5d0322..e0d4f24b6039 100644
> --- a/Documentation/driver-api/index.rst
> +++ b/Documentation/driver-api/index.rst
> @@ -7,6 +7,12 @@ of device drivers.  This document is an only somewhat organized collection
> of some of those interfaces — it will hopefully get better over time!  The
> available subsections can be seen below.
> 
> +.. uml::
> +
> +   Alice -> Bob: Hi!
> +   Alice <- Bob: How are you?
> +
> +
> .. class:: toc-title
> 
> 	   Table of contents
> diff --git a/Documentation/sphinx/dummy.py b/Documentation/sphinx/dummy.py
> new file mode 100644
> index 000000000000..cfac42886ebd
> --- /dev/null
> +++ b/Documentation/sphinx/dummy.py
> @@ -0,0 +1,24 @@
> +from sphinx.util.compat import Directive
> +from docutils import nodes
> +from docutils.parsers.rst import directives
> +
> +class IgnoreOptions(object):
> +    def __getitem__(self, key):
> +        return directives.unchanged
> +
> +def create_setup(directives):
> +    def setup(app):
> +        for d in directives:
> +            class TextDirective(Directive):
> +                has_content = True
> +                option_spec = IgnoreOptions()
> +
> +                def run(self):
> +                    text = '\n'.join(self.content)
> +                    return [nodes.literal_block('', text,
> +                                          classes=['code',
> +                                                   'missing-plugin',
> +                                                   'missing-plugin-%s' % d])]
> +
> +            app.add_directive(d, TextDirective)
> +    return setup
> diff --git a/Documentation/sphinx/plantuml.py b/Documentation/sphinx/plantuml.py
> new file mode 100644
> index 000000000000..0007bc7f24fd
> --- /dev/null
> +++ b/Documentation/sphinx/plantuml.py
> @@ -0,0 +1,7 @@
> +# -*- coding: utf-8 -*-
> +from dummy import create_setup
> +
> +try:
> +    from sphinxcontrib.plantuml import *
> +except:
> +    setup = create_setup(['uml'])
