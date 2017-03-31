Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:15925 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933465AbdCaMyI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 08:54:08 -0400
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 1/2] Documentation/sphinx: kerneldoc: add "unused-functions"
In-Reply-To: <20170331071632.6209-1-johannes@sipsolutions.net>
References: <20170331071632.6209-1-johannes@sipsolutions.net>
Date: Fri, 31 Mar 2017 15:54:04 +0300
Message-ID: <878tnl38ur.fsf@intel.com> (sfid-20170331_145442_551233_2D519BBB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 31 Mar 2017, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> When adding functions one by one into documentation, in order to
> order/group things properly, it's easy to miss things. Allow use
> of the kernel-doc directive with "unused-functions" like this
>
> .. kernel-doc:: <filename>
>    :unused-functions:

I'm sure the parameter name could be improved to capture what you mean
better; alas I don't have a suggestion.

>
> to output anything previously unused from that file. This allows
> grouping things but still making sure that the documentation has
> all the functions.
>
> Internally this works by collecting (per-file) those functions
> (and enums, structs, doc sections...) that are explicitly used,
> and invoking the kernel-doc script with "-nofunction" later.

A quick thought that I don't have the time to check now, but should be
checked before merging: Is the order of directive extension execution
deterministic if the Sphinx run is parallelized (sphinx-build -j)? Is it
deterministic within an rst file? Surely it's not deterministic when
called from several rst files? The latter is, perhaps, acceptable, but
the former not.

BR,
Jani.


>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  Documentation/sphinx/kerneldoc.py | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/sphinx/kerneldoc.py b/Documentation/sphinx/kerneldoc.py
> index d15e07f36881..79fc1491348a 100644
> --- a/Documentation/sphinx/kerneldoc.py
> +++ b/Documentation/sphinx/kerneldoc.py
> @@ -41,6 +41,9 @@ from sphinx.ext.autodoc import AutodocReporter
>  
>  __version__  = '1.0'
>  
> +# per-file list
> +_used_fns = {}
> +
>  class KernelDocDirective(Directive):
>      """Extract kernel-doc comments from the specified file"""
>      required_argument = 1
> @@ -50,6 +53,7 @@ class KernelDocDirective(Directive):
>          'functions': directives.unchanged_required,
>          'export': directives.unchanged,
>          'internal': directives.unchanged,
> +        'unused-functions': directives.unchanged,
>      }
>      has_content = False
>  
> @@ -60,6 +64,10 @@ class KernelDocDirective(Directive):
>          filename = env.config.kerneldoc_srctree + '/' + self.arguments[0]
>          export_file_patterns = []
>  
> +        if not filename in _used_fns:
> +            _used_fns[filename] = []
> +        _used_fns_this_file = _used_fns[filename]
> +
>          # Tell sphinx of the dependency
>          env.note_dependency(os.path.abspath(filename))
>  
> @@ -73,10 +81,16 @@ class KernelDocDirective(Directive):
>              cmd += ['-internal']
>              export_file_patterns = str(self.options.get('internal')).split()
>          elif 'doc' in self.options:
> -            cmd += ['-function', str(self.options.get('doc'))]
> +            f = str(self.options.get('doc'))
> +            cmd += ['-function', f]
> +            _used_fns_this_file.append(f)
> +        elif 'unused-functions' in self.options:
> +            for f in _used_fns_this_file:
> +                cmd += ['-nofunction', f]
>          elif 'functions' in self.options:
>              for f in str(self.options.get('functions')).split():
>                  cmd += ['-function', f]
> +                _used_fns_this_file.append(f)
>  
>          for pattern in export_file_patterns:
>              for f in glob.glob(env.config.kerneldoc_srctree + '/' + pattern):

-- 
Jani Nikula, Intel Open Source Technology Center
